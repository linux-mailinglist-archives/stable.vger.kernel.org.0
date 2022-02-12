Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4444B3879
	for <lists+stable@lfdr.de>; Sun, 13 Feb 2022 00:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbiBLXFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Feb 2022 18:05:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232259AbiBLXFj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Feb 2022 18:05:39 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C545F8CB
        for <stable@vger.kernel.org>; Sat, 12 Feb 2022 15:05:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1644707132;
        bh=MxDe+n2MqdtfQ4AoX9ocFP9x6Ub65RVrW6/eLRcuZuA=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=ecmtyj7PYzXQIqS5i0ioEo8iFV1Jae/qlXhYv7WKqzeEvJ2t90KYfIkBaKjybjIrs
         egz/FIaFTDSn0WnKfVWR5+00lmWUqP/gXQt/0IioYnXbGAUvNUdQIBNhSk8COgE9mz
         I734+96fhF2VoJ77J1LhKkE6KlvIzX/zl5DVeyQ4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from esprimo-mx.users.agdsn.de ([141.30.226.129]) by mail.gmx.net
 (mrgmx105 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1M2f5T-1nIjjE3jd1-0049cI; Sun, 13 Feb 2022 00:00:23 +0100
From:   Armin Wolf <W_Armin@gmx.de>
To:     stable@vger.kernel.org
Cc:     pali@kernel.org
Subject: [PATCH] hwmon: (dell-smm) Speed up setting of fan speed
Date:   Sun, 13 Feb 2022 00:00:21 +0100
Message-Id: <20220212230021.18725-1-W_Armin@gmx.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:9YBEOE/0ksjmt2wjWNJn0556d4Eyvekd8JmtnGeTGa3spzkehYT
 DwspkFn4Pw6cAIhUBshRXDtwRwe9tuprNj1FzuhJ57T6SdWdR4nDmEfUseSeoXa3zUqXiiJ
 WGC8CXg5E0kPEOzjhngcAtRtITGu/HuEjqbAHfbdKo1yTGXUmYTtWE4/zgmr9teDU+I521k
 jcza1UKMipD7GhpjFloUA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:NropN14ZhH4=:11clsb5zMIgUCXpdA3n9Uo
 3SXd6bYtyNQs+IHGllJAvZoWN7XnSGh1u+k+ipbSLjCXP892dOz3hP1hBxFRRNJRvnj6B0iPM
 MO67ZBIURws8aOOULKOFwHT6vWy4NMFa7JkPoB57820LA/fXuZPaPN3VR7fhVsK0RVeki2Y1e
 lSTJWeRIqOTj69l2EvtMlVWvfPb3764Zixbbvfq2vsPsjV0A37G86Zp/6pP6IRFnwgqsbXJXs
 QIjZePFIhkIAEvZxTt11cxUxiiIZf883z9dALtbQGt2ScBnH47pRkkJZ6L7Tb3OLSgDXrDB4T
 nXvfX6GjhUf84VcbLJdpAqlroZeI03fWG9fzkAPZnAXoZTPr/yHJkgkeAvOVkFwfPCEcHZ4Er
 qblXksGwS4OL7VKPUeMpVbpdVm1WhGncl6/+ZbVqlqG0LsLwpD0LAoPv+PBQ5W3xa7JKbU9Gz
 6f2MAQgf84mYs8cY0m20sK7OF/uORmkERgzFrRdOiZqzSdfNEVzdEGtJFXwP7XHSRMXEn+ZrY
 rCUqJvT9JpSocVhPHFF7Je7bmtRvkKWnt6P4QT8DXp+/Z9dX/rt3I0ypCMIBnSmEVW3ZBTJ3z
 qSzf6KjHmaxWwKxgjbjbw9KxH2DYMw+GQZ+JgsgO0j3QBHbds8Mc/3uXFwzZrlujjlwpIoZae
 44Q02CE9tCEsrHeBX1WaPGHy4V0/zUyViCdX2B/V4nnCJVdFucU5EsRJ0Q8Tmdqu/ziV9B6Xr
 Wm8yeOWFR1SHnUndddSiuealtRkR+RItlGjkUpR/sKHBkqgixI0TTQRoIv8Mih3s8GgH+1U+X
 YWaHJIWtaiaFCKBejNrZUTrDm/7HFR8u152oB85Fmdj9c+dd+cd1cAoqUl1JiXd6oeiA9ucSr
 HdtwjNleJh+W0QR3M9VF73yqLkS9Qwk4A2UrgU4MXKo52B7XbJ1Qyc/5aPkrhr9aMxJyfk+ew
 7t+m175849xdBRRbgrqah+M05kIt9z41QpgAGNe7DKeVWl5w09WpSWnu1VxvcYUn4vZvJS1F1
 PkCr7EsYGDoQludvAGdeOpoFNhyNSeJn35URzSCfJ0FKmTDPzxCQs5kXB9iuActev0gjAeudR
 dTZaHIChcIr9fs=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit c0d79987a0d82671bff374c07f2201f9bdf4aaa2 upstream.

When setting the fan speed, i8k_set_fan() calls i8k_get_fan_status(),
causing an unnecessary SMM call since from the two users of this
function, only i8k_ioctl_unlocked() needs to know the new fan status
while dell_smm_write() ignores the new fan status.
Since SMM calls can be very slow while also making error reporting
difficult for dell_smm_write(), remove the function call from
i8k_set_fan() and call it separately in i8k_ioctl_unlocked().

This patch was originally a performance optimization, but it turned
out a user with a buggy machine requires this patch since it also
fixes error reporting when i8k_get_fan_status fails.
https://github.com/lm-sensors/lm-sensors/pull/383

Tested on a Dell Inspiron 3505.

Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
=2D--
 drivers/hwmon/dell-smm-hwmon.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hwmon=
.c
index 47fce97996de..9cb1c3588038 100644
=2D-- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -326,7 +326,7 @@ static int i8k_enable_fan_auto_mode(const struct dell_=
smm_data *data, bool enabl
 }

 /*
- * Set the fan speed (off, low, high). Returns the new fan status.
+ * Set the fan speed (off, low, high, ...).
  */
 static int i8k_set_fan(const struct dell_smm_data *data, int fan, int spe=
ed)
 {
@@ -338,7 +338,7 @@ static int i8k_set_fan(const struct dell_smm_data *dat=
a, int fan, int speed)
 	speed =3D (speed < 0) ? 0 : ((speed > data->i8k_fan_max) ? data->i8k_fan=
_max : speed);
 	regs.ebx =3D (fan & 0xff) | (speed << 8);

-	return i8k_smm(&regs) ? : i8k_get_fan_status(data, fan);
+	return i8k_smm(&regs);
 }

 static int __init i8k_get_temp_type(int sensor)
@@ -452,7 +452,7 @@ static int
 i8k_ioctl_unlocked(struct file *fp, struct dell_smm_data *data, unsigned =
int cmd, unsigned long arg)
 {
 	int val =3D 0;
-	int speed;
+	int speed, err;
 	unsigned char buff[16];
 	int __user *argp =3D (int __user *)arg;

@@ -513,7 +513,11 @@ i8k_ioctl_unlocked(struct file *fp, struct dell_smm_d=
ata *data, unsigned int cmd
 		if (copy_from_user(&speed, argp + 1, sizeof(int)))
 			return -EFAULT;

-		val =3D i8k_set_fan(data, val, speed);
+		err =3D i8k_set_fan(data, val, speed);
+		if (err < 0)
+			return err;
+
+		val =3D i8k_get_fan_status(data, val);
 		break;

 	default:
=2D-
2.30.2

