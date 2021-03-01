Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9DC7328498
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234673AbhCAQiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:38:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:36926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232663AbhCAQc1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:32:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F55C64F2B;
        Mon,  1 Mar 2021 16:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615884;
        bh=ymdq+xzvkAsE44SwFhAffqL61NBddWlAT9+XphAUN6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b2jUijpfYQ3zMeXRT4ItgIKzLO6957J+0mga7uLXZBmZXmXsm8B++1xvhSYuPrF5z
         qKSJ4gGBEl4FbMCHjiI+TA5fmge6VWoX+aN2SoRFaGLcmt3rd32aSYs8exaOjc808H
         PWFWjLaX7h0EL0Vi3BTRUoD7OGFU+7zDVrOSAQPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ludvig Norgren Guldhag <ludvigng@gmail.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.9 094/134] Input: i8042 - add ASUS Zenbook Flip to noselftest list
Date:   Mon,  1 Mar 2021 17:13:15 +0100
Message-Id: <20210301161018.197046759@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcos Paulo de Souza <mpdesouza@suse.com>

commit b5d6e7ab7fe7d186878142e9fc1a05e4c3b65eb9 upstream.

After commit 77b425399f6d ("Input: i8042 - use chassis info to skip
selftest on Asus laptops"), all modern Asus laptops have the i8042
selftest disabled. It has done by using chassys type "10" (laptop).

The Asus Zenbook Flip suffers from similar suspend/resume issues, but
it _sometimes_ work and sometimes it doesn't. Setting noselftest makes
it work reliably. In this case, we need to add chassis type "31"
(convertible) in order to avoid selftest in this device.

Reported-by: Ludvig Norgren Guldhag <ludvigng@gmail.com>
Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
Link: https://lore.kernel.org/r/20210219164638.761-1-mpdesouza@suse.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-x86ia64io.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -579,6 +579,10 @@ static const struct dmi_system_id i8042_
 			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-CS"),
 		},
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_CHASSIS_TYPE, "31"), /* Convertible Notebook */
+		},
 	},
 	{ }
 };


