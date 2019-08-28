Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01D4CA0791
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 18:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbfH1Qk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 12:40:57 -0400
Received: from mout.gmx.net ([212.227.15.19]:42507 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726315AbfH1Qk4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Aug 2019 12:40:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1567010433;
        bh=TTgIyj6CUcmrfc1E72QNUBxFB3XocZ1qN2nCyjJBjWw=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=HdMNHODYnOWKK3H7jIdgDoz2ZH53byqAJoZL+OUlrfNsdNZtVXvu6TMmIK+VyMIK3
         nTmIkwW+WHtI/L57TAcvwvFAzgJCP9A3j/xyIyMTgoRxDeg3mAho26KYnhLiwLYrEX
         PIRZ9goDCFuLAPILdlXsaXVeIvcCh2CAdGmoHZ3M=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.106]) by mail.gmx.com
 (mrgmx003 [212.227.17.190]) with ESMTPSA (Nemesis) id
 0Lk7fW-1idiKR00dO-00c7MT; Wed, 28 Aug 2019 18:40:33 +0200
From:   Stefan Wahren <wahrenst@gmx.net>
To:     stable@vger.kernel.org
Cc:     Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Eric Anholt <eric@anholt.net>, Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH] watchdog: bcm2835_wdt: Fix module autoload
Date:   Wed, 28 Aug 2019 18:40:14 +0200
Message-Id: <1567010414-3518-1-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
X-Provags-ID: V03:K1:DEmTmdJnszxQEf5N7RCFI1HtTdznckBPdARs/00lEDszOEoeKT9
 u9xwqHxYwfH88da2eB8i3p+MDF2jzXsXiRPTkZ5FviMDN6rwsePtY9Qx+qqpnfxzJm8BKfo
 zTklG9DAV1gX735U03QlnQ2QUwLuj7MwtfmPJ+hOrrOpbn8NDWBXVmBm5Rdemsa2k//6Udc
 K3yVEzj5CrHazHDlNChvg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:nwO74XWu1ow=:Nn572esmHAa3sqoeNikYDt
 bTneOeOSWxt49gM8HEjDbW8ezfbxBh+yZ/IZqERQhkDl+LYe5gUcJIufWzay0NE47+/0Fwzfv
 eOjGfKtmuNWpPYL3drh+smYSsWNnxEY52gmcyam4YoVqW7W1SfhUf14kkzlhVzSS2NqbGRfbH
 2jhA4YbqqE/+5NcewQhkZo8jBEE0oAR4xgpYPwkg2aqTXgeTVkMa9BpWCoLiZolHiiCJ1JPHq
 kf5pYMwBeZCNHk8nZ4oG+gKos9LsvokMHYAJw1irADmzt3Fzw8ZaLXC2G0pdXyJHq/ULwjHNt
 xoZrO8taWEHkKz5Trj4Pu4EDVxFrFYPfec5JvqarYnU1slXj/k/+RUjK7++CPe6FSu8CnAKMJ
 4pSoyEhPBexvnOgAiLbRLRJeXXBKWmj4rN/BxKRGbm+LQIAWcCPkubxpq/SLj/nHj+EMj4MJD
 xw7y3uJd+1UUQlyoRDTybUk+J1WNni9wICkVw1l7wKwuBUYYU3CwmL220d1SF+gSHUA7QaczC
 kZgUtu4hX23N1hfHIgowlYt7WP+0REpcexCiNPwFMl+YU6msNNkHGkqwkeD69HMLJXPygOFAD
 aiMxUsSCi1VwfAlm5GWDf3QuFsq7xl7RtM9HCBf39aZs4rhOpAfs1L0B1Cz75MMJQEbdChCRn
 N1z18ifCT4w1pj5EQ3HDZAhHAKsqLltHPdFuMZt7CHSqd8RNuwHOAtPXEIcQ7NecXM8Kp6gk1
 WJnN+PPOMKiqKkFNY/pyANZ3SUSr83ra5hsk4SE75haEycvwKOUfYIs7ti0AjbztSGjuP0m7l
 519dr513h1xiSdMSrLu8+k0weI+Q2miROo6BFAhEWOj27gQgERwBeVA27X0mIXkXhd4NQmWUc
 bWLpJI1xMaFilP/Hf7pWoU/MnKCVnYeYIKxtnfEQUcyRjNYo2Yrzn7bX1fWIMmjFiQvFxLjwL
 R2aDp6GryCLrdAKviXOD2e/odGjjvrARx8pLYup0SBzXtU1arKDM9cp8tlakyoqypAU4DZ1D5
 Ayhh0IxyLsGHJu2fXJKdstZi/4+CZsvWRLzLY24H2/WRofq1ksBFBONjF08+F1QjoyMocfvgU
 QzJGjEs2E9vpS9y6q84JJb3dRwXsUoE2iFT+7ND/uaCc2friIrwEJpziA==
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 215e06f0d18d5d653d6ea269e4dfc684854d48bf upstream.

The commit 5e6acc3e678e ("bcm2835-pm: Move bcm2835-watchdog's DT probe
to an MFD.") broke module autoloading on Raspberry Pi. So add a
module alias this fix this.

Fixes: 5e6acc3e678e ("bcm2835-pm: Move bcm2835-watchdog's DT probe to an M=
FD.")
Cc: <stable@vger.kernel.org>
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
=2D--
 drivers/watchdog/bcm2835_wdt.c | 1 +
 1 file changed, 1 insertion(+)

Hi Greg,
please apply to the Linux 5.2 stable branch, because without this patch
the Raspberry Pi might not be able to reboot.

Regards
Stefan

diff --git a/drivers/watchdog/bcm2835_wdt.c b/drivers/watchdog/bcm2835_wdt=
.c
index 560c1c5..f4937a9 100644
=2D-- a/drivers/watchdog/bcm2835_wdt.c
+++ b/drivers/watchdog/bcm2835_wdt.c
@@ -240,6 +240,7 @@ module_param(nowayout, bool, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (defa=
ult=3D"
 				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");

+MODULE_ALIAS("platform:bcm2835-wdt");
 MODULE_AUTHOR("Lubomir Rintel <lkundrak@v3.sk>");
 MODULE_DESCRIPTION("Driver for Broadcom BCM2835 watchdog timer");
 MODULE_LICENSE("GPL");
=2D-
2.7.4

