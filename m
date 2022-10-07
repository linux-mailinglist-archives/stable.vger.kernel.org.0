Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 905905F7713
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 12:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiJGKw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Oct 2022 06:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiJGKw2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Oct 2022 06:52:28 -0400
X-Greylist: delayed 559 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 07 Oct 2022 03:52:24 PDT
Received: from mail.astralinux.ru (mail.astralinux.ru [217.74.38.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7318A74DFB;
        Fri,  7 Oct 2022 03:52:24 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id 48A1B314098A;
        Fri,  7 Oct 2022 13:43:06 +0300 (MSK)
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id rI2mS3rOt4Ax; Fri,  7 Oct 2022 13:43:05 +0300 (MSK)
Received: from localhost (localhost [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id A02AD3140957;
        Fri,  7 Oct 2022 13:43:05 +0300 (MSK)
X-Virus-Scanned: amavisd-new at astralinux.ru
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id B7pUo_GVpgBY; Fri,  7 Oct 2022 13:43:05 +0300 (MSK)
Received: from work-laptop.astralinux.ru (unknown [10.177.20.36])
        by mail.astralinux.ru (Postfix) with ESMTPSA id A03EE314001C;
        Fri,  7 Oct 2022 13:43:04 +0300 (MSK)
From:   Andrew Chernyakov <acherniakov@astralinux.ru>
To:     acherniakov@astralinux.ru, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        lvc-project@linuxtesting.org
Subject: [PATCH 5.10 1/1] Backport of rpmsg: qcom: glink: replace strncpy() with  strscpy_pad()
Date:   Fri,  7 Oct 2022 13:41:20 +0300
Message-Id: <20221007104120.75208-2-acherniakov@astralinux.ru>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221007104120.75208-1-acherniakov@astralinux.ru>
References: <20221007104120.75208-1-acherniakov@astralinux.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The use of strncpy() is considered deprecated for NULL-terminated
strings[1]. Replace strncpy() with strscpy_pad(), to keep existing
pad-behavior of strncpy, strncpy was found on line 1424 of
/drivers/rpmsg/qcom_glink_native.c.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Andrew Chernyakov <acherniakov@astralinux.ru>
---
 drivers/rpmsg/qcom_glink_native.c | 2 +-
 drivers/rpmsg/qcom_smd.c          | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rpmsg/qcom_glink_native.c b/drivers/rpmsg/qcom_glink=
_native.c
index 4840886532ff..66a63b205744 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -1424,7 +1424,7 @@ static int qcom_glink_rx_open(struct qcom_glink *gl=
ink, unsigned int rcid,
 		}
=20
 		rpdev->ept =3D &channel->ept;
-		strncpy(rpdev->id.name, name, RPMSG_NAME_SIZE);
+		strscpy_pad(rpdev->id.name, name, RPMSG_NAME_SIZE);
 		rpdev->src =3D RPMSG_ADDR_ANY;
 		rpdev->dst =3D RPMSG_ADDR_ANY;
 		rpdev->ops =3D &glink_device_ops;
diff --git a/drivers/rpmsg/qcom_smd.c b/drivers/rpmsg/qcom_smd.c
index 0b1e853d8c91..b5167ef93abf 100644
--- a/drivers/rpmsg/qcom_smd.c
+++ b/drivers/rpmsg/qcom_smd.c
@@ -1073,7 +1073,7 @@ static int qcom_smd_create_device(struct qcom_smd_c=
hannel *channel)
=20
 	/* Assign public information to the rpmsg_device */
 	rpdev =3D &qsdev->rpdev;
-	strncpy(rpdev->id.name, channel->name, RPMSG_NAME_SIZE);
+	strscpy_pad(rpdev->id.name, channel->name, RPMSG_NAME_SIZE);
 	rpdev->src =3D RPMSG_ADDR_ANY;
 	rpdev->dst =3D RPMSG_ADDR_ANY;
=20
@@ -1304,7 +1304,7 @@ static void qcom_channel_state_worker(struct work_s=
truct *work)
=20
 		spin_unlock_irqrestore(&edge->channels_lock, flags);
=20
-		strncpy(chinfo.name, channel->name, sizeof(chinfo.name));
+		strscpy_pad(chinfo.name, channel->name, sizeof(chinfo.name));
 		chinfo.src =3D RPMSG_ADDR_ANY;
 		chinfo.dst =3D RPMSG_ADDR_ANY;
 		rpmsg_unregister_device(&edge->dev, &chinfo);
--=20
2.35.1

