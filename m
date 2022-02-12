Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A62714B3875
	for <lists+stable@lfdr.de>; Sat, 12 Feb 2022 23:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbiBLW7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Feb 2022 17:59:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbiBLW7m (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Feb 2022 17:59:42 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD6A5C378
        for <stable@vger.kernel.org>; Sat, 12 Feb 2022 14:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1644706776;
        bh=BFwPTU7Ico0TNSQECgxLXKSg/Dk6YtTM1/szrVGvp/Y=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=i3qGFnXwxo8eOoWa+YYlWukzZ30Lz+LWCMGwIOB7Wk+dHu7VEUhyPNqzaFf4hL/lH
         qUOdbY5GLR+2dp5Eetn6n9WToGXprw8xShmaHQN4TEfO1PE2GInzwxSnxRqxWEoPWn
         /b+oQJ9fiqBJTS9wnfiFJvMqawpjjWv6HF6NAmxQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from esprimo-mx.users.agdsn.de ([141.30.226.129]) by mail.gmx.net
 (mrgmx004 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MRmfo-1nhnA02aC2-00TCUa; Sat, 12 Feb 2022 23:54:26 +0100
From:   Armin Wolf <W_Armin@gmx.de>
To:     stable@vger.kernel.org
Cc:     pali@kernel.org
Subject: [PATCH] hwmon: (dell-smm) Speed up setting of fan speed
Date:   Sat, 12 Feb 2022 23:54:18 +0100
Message-Id: <20220212225418.16662-1-W_Armin@gmx.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:uqyYr0IVEQXGNkBH9HeL2fPwPZlflxUAplai8CTyVnS1TsOiS21
 ofhmdVsw4TipW13mb77w/0EhiViHt14H/S+5a41QPyk7CeosLRpXETmm6tLqo6CQvSZWcuT
 yRle3gTIlQ04IibbKc6OhS4rh3TC3lwA2nWALdvuV54lPwSOf4kSW4nw6ko88QVckdl4jBT
 y2oDgSNEj4qGqpve6JH6A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:7gMmFhYj1gA=:IoTP35qarkZn7gYMXIeo67
 QCEqHkhlRDHp0LqW1YyGrDkPLHCCuSqwXHtUoGO0OtAXV7C/ZJIdxZTN9LuYMUkRYwzF2xcby
 HW+HkxynTMkZHLSJrKEtbw3wfP32CntUsKaJSfMIG9EEOxfVL0Kc/BH1HKpvHFQLmq0Os5X8s
 f7Y64fTfPAb0eTg1Yyx+lS3oJky/loETv09XR6pfEk+fjdrnFRehV188nyz5UJo3uD/IQvz+p
 VEhBwyaWvKNnDHrcHeERVg0jQ0zXsOlNIPMc+aTSpvOBVK32Y0DoiP2rMPYE3LycFgF6Pq9Vs
 RdFIwvG6eoJhC/DPwvkk0tFNCYrZF284bqplXaVha31NtU+sddnWtu2KNp+jf70iE9r4akN6U
 2h6iN5IpK4MtJ/I7CFy+B0K7Zu1xy+/PbTyC+lZlWWuiSK/WNEIjDgg8eFoglTnE7CEwrlPOo
 Bj2xCkdod2V4xXntgh7Lz6IxcKgxtIPLJHqUSJEH9b//lT2MZ8IUUNJje74QJNGlak+KFAbDy
 Nbekcsz1spT6hOrT2RYDqREPFyy3HihA2kX2lPzUf4kLq0YF4kWg8mTNJq+UXSzox8evBWcrJ
 SKopkf06H4ZE855e0K46oBJwoI6L1RytdHa2qOhS65my5qpBAz8ZjNQH3wRK7eULYq/b80Kh8
 gcPKzgtG+w/efkwZYOM9zts9WF16+7Cmc5amazA2dHVGjJjODhLjNCyZIkS0U/Tyii42g3LPb
 b1qbtXdVX2+e1IfWtIY0WhmF2eCr4KrWzgATj5yo3OkPZxm+B4Y8UfhgtXSDiE3jzCFXnmBcZ
 vM5Xgy57ULFZpH8aYjmXrSFYv0QlDeQ/suCB5PYqG5CpcEwtwjMLXqPvifj/xJ0DxDcIhsGcX
 sAj4tIS55V0oOUIhfK+A84UtLPC7fjXJJ45FNKHuvjHQGwLrAE4mZCwYLtqDQt8GVBCB7xSyw
 yI+4o5VwMK0EGX5jnkJkBTf10/Y5nYZuIByYc83X7FQFIUqjzb23Y5Z56Etf8YySFFDrO0hRg
 YspipKCdDcGjCylpdG0CCcAJQF/5MWFpfpZEnrzWKUpG1BGBA0Z4iY1OTSreEezIvt0dhh8Mj
 XnCCUoogFdOLS0=
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

Since this patch was backported from kernel 5.16, the data argument
of i8k_set_fan and i8k_get_fan_status was omitted (it exists since
kernel 5.15).

This patch was originally a performance optimization, but it turned
out a user with a buggy machine requires this patch since it also
fixes error reporting when i8k_get_fan_status fails.
https://github.com/lm-sensors/lm-sensors/pull/383

Tested on a Dell Inspiron 3505.

Cc: <stable@vger.kernel.org> # 5.10.x
Cc: <stable@vger.kernel.org> # 5.4.x
Cc: <stable@vger.kernel.org> # 4.x.x
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
=2D--
 drivers/hwmon/dell-smm-hwmon.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hwmon=
.c
index 87f401100466..10c7b6295b02 100644
=2D-- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -317,7 +317,7 @@ static int i8k_enable_fan_auto_mode(bool enable)
 }

 /*
- * Set the fan speed (off, low, high). Returns the new fan status.
+ * Set the fan speed (off, low, high, ...).
  */
 static int i8k_set_fan(int fan, int speed)
 {
@@ -329,7 +329,7 @@ static int i8k_set_fan(int fan, int speed)
 	speed =3D (speed < 0) ? 0 : ((speed > i8k_fan_max) ? i8k_fan_max : speed=
);
 	regs.ebx =3D (fan & 0xff) | (speed << 8);

-	return i8k_smm(&regs) ? : i8k_get_fan_status(fan);
+	return i8k_smm(&regs);
 }

 static int i8k_get_temp_type(int sensor)
@@ -443,7 +443,7 @@ static int
 i8k_ioctl_unlocked(struct file *fp, unsigned int cmd, unsigned long arg)
 {
 	int val =3D 0;
-	int speed;
+	int speed, err;
 	unsigned char buff[16];
 	int __user *argp =3D (int __user *)arg;

@@ -504,7 +504,11 @@ i8k_ioctl_unlocked(struct file *fp, unsigned int cmd,=
 unsigned long arg)
 		if (copy_from_user(&speed, argp + 1, sizeof(int)))
 			return -EFAULT;

-		val =3D i8k_set_fan(val, speed);
+		err =3D i8k_set_fan(val, speed);
+		if (err < 0)
+			return err;
+
+		val =3D i8k_get_fan_status(val);
 		break;

 	default:
=2D-
2.30.2

