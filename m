Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113953C44E1
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234340AbhGLGWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:22:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234346AbhGLGVF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:21:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECC586113E;
        Mon, 12 Jul 2021 06:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070694;
        bh=enivGW5S8figon2mHX17bP7vwFjM+yvQSXMNBhr8mBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ep6X1wogilaaSzSUNU/PUKX7g7ikzV1yfd3++M8wxNOkkisy2u6F6Mev/KA+FvB2S
         XvQYU2Gs9cjGK6CfOuT8ddy1lEwL3fg4nx3pyyUNawdG8AbpeslCXWFXz9XXkq8Rxr
         QUhoO1pG15fmxXmJcmmZxeVmbvKcYKKExeEtG5Lo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jan=20Kundr=C3=A1t?= <jan.kundrat@cesnet.cz>,
        =?UTF-8?q?V=C3=A1clav=20Kubern=C3=A1t?= <kubernat@cesnet.cz>,
        Guenter Roeck <linux@roeck-us.net>,
        =?UTF-8?q?V=C3=A1clav=20Kubern=C3=A1t?= <kubernat@ceesnet.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 099/348] hwmon: (max31790) Report correct current pwm duty cycles
Date:   Mon, 12 Jul 2021 08:08:03 +0200
Message-Id: <20210712060714.807228783@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 897f6339893b741a5d68ae8e2475df65946041c2 ]

The MAX31790 has two sets of registers for pwm duty cycles, one to request
a duty cycle and one to read the actual current duty cycle. Both do not
have to be the same.

When reporting the pwm duty cycle to the user, the actual pwm duty cycle
from pwm duty cycle registers needs to be reported. When setting it, the
pwm target duty cycle needs to be written. Since we don't know the actual
pwm duty cycle after a target pwm duty cycle has been written, set the
valid flag to false to indicate that actual pwm duty cycle should be read
from the chip instead of using cached values.

Cc: Jan Kundrát <jan.kundrat@cesnet.cz>
Cc: Václav Kubernát <kubernat@cesnet.cz>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Václav Kubernát <kubernat@ceesnet.cz>
Reviewed-by: Jan Kundrát <jan.kundrat@cesnet.cz>
Link: https://lore.kernel.org/r/20210526154022.3223012-3-linux@roeck-us.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/hwmon/max31790.rst | 3 ++-
 drivers/hwmon/max31790.c         | 6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/hwmon/max31790.rst b/Documentation/hwmon/max31790.rst
index 84c62a12ef3a..9f12aac4fab5 100644
--- a/Documentation/hwmon/max31790.rst
+++ b/Documentation/hwmon/max31790.rst
@@ -39,5 +39,6 @@ fan[1-12]_input    RO  fan tachometer speed in RPM
 fan[1-12]_fault    RO  fan experienced fault
 fan[1-6]_target    RW  desired fan speed in RPM
 pwm[1-6]_enable    RW  regulator mode, 0=disabled, 1=manual mode, 2=rpm mode
-pwm[1-6]           RW  fan target duty cycle (0-255)
+pwm[1-6]           RW  read: current pwm duty cycle,
+                       write: target pwm duty cycle (0-255)
 ================== === =======================================================
diff --git a/drivers/hwmon/max31790.c b/drivers/hwmon/max31790.c
index 117fb79ef294..344be7829d58 100644
--- a/drivers/hwmon/max31790.c
+++ b/drivers/hwmon/max31790.c
@@ -104,7 +104,7 @@ static struct max31790_data *max31790_update_device(struct device *dev)
 				data->tach[NR_CHANNEL + i] = rv;
 			} else {
 				rv = i2c_smbus_read_word_swapped(client,
-						MAX31790_REG_PWMOUT(i));
+						MAX31790_REG_PWM_DUTY_CYCLE(i));
 				if (rv < 0)
 					goto abort;
 				data->pwm[i] = rv;
@@ -299,10 +299,10 @@ static int max31790_write_pwm(struct device *dev, u32 attr, int channel,
 			err = -EINVAL;
 			break;
 		}
-		data->pwm[channel] = val << 8;
+		data->valid = false;
 		err = i2c_smbus_write_word_swapped(client,
 						   MAX31790_REG_PWMOUT(channel),
-						   data->pwm[channel]);
+						   val << 8);
 		break;
 	case hwmon_pwm_enable:
 		fan_config = data->fan_config[channel];
-- 
2.30.2



