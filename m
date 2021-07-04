Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2EEA3BB30A
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233104AbhGDXRD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:17:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233762AbhGDXOj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2778761996;
        Sun,  4 Jul 2021 23:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440225;
        bh=enivGW5S8figon2mHX17bP7vwFjM+yvQSXMNBhr8mBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X11sca0lGQu0+T65v0pV1VqrSF05C7/70PmxnKpbBHw8QFducmxpaaFOjDZAzs/Ps
         rlmXRWuKZB1FDMBmJSdSzHOnvCOXWAKg0dS223eRRhf4Ium7cEhZeh9fqfNJjlLeHT
         0cDWAXhNjOfJTSPYQoZ9//0LyzvwHLvHkewss1qUfDH5eU3E2xKXY1+qiLZnP2DHuK
         QEra2BIpeCclVt8FQvCzGZYSbLwCUovPP0pU7BvORaCWEPlPYw4Jyr5u/5hOVD0fb0
         wSFN9P4s2uwiGNTHZW51Dsy0a0cqmhXf5k3lz5WqS8lebWE/NxttWGRlqJ5ckGPiru
         YS6eZI5ikiHiw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>,
        =?UTF-8?q?Jan=20Kundr=C3=A1t?= <jan.kundrat@cesnet.cz>,
        =?UTF-8?q?V=C3=A1clav=20Kubern=C3=A1t?= <kubernat@cesnet.cz>,
        =?UTF-8?q?V=C3=A1clav=20Kubern=C3=A1t?= <kubernat@ceesnet.cz>,
        Sasha Levin <sashal@kernel.org>, linux-hwmon@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 36/50] hwmon: (max31790) Report correct current pwm duty cycles
Date:   Sun,  4 Jul 2021 19:09:24 -0400
Message-Id: <20210704230938.1490742-36-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230938.1490742-1-sashal@kernel.org>
References: <20210704230938.1490742-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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

