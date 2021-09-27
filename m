Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7669419C7C
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238005AbhI0R3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:29:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237998AbhI0R0I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:26:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 950C761411;
        Mon, 27 Sep 2021 17:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762985;
        bh=AT2QYDX/clU5Q1ylQYfJn92IkLNMMbYm5DX5wMO0jZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pZspe8YdQrTD4utLuzMum6t8RDhi+Qx/u/x6vjOLhIJxgQhZH6LIJsm76K5zv27Zl
         +/N1EI+tkqmU1uYTPjp9627GYCpkD/pYJVkqgeRihKrjWJUYcSpSKaDPDqkBR7mvUH
         D76DPiB5yD/tFec6YZ46ABhz09959IPE7boaWzcc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bodo Stroesser <bostroesser@gmail.com>,
        Maurizio Lombardi <mlombard@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 093/162] scsi: target: Fix the pgr/alua_support_store functions
Date:   Mon, 27 Sep 2021 19:02:19 +0200
Message-Id: <20210927170236.652852872@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit ef7ae7f746e95c6fa4ec2bcfacb949c36263da78 ]

Commit 356ba2a8bc8d ("scsi: target: tcmu: Make pgr_support and alua_support
attributes writable") introduced support for changeable alua_support and
pgr_support target attributes. These can only be changed if the backstore
is user-backed, otherwise the kernel returns -EINVAL.

This triggers a warning in the targetcli/rtslib code when performing a
target restore that includes non-userbacked backstores:

  # targetctl restore
  Storage Object block/storage1: Cannot set attribute alua_support:
  [Errno 22] Invalid argument, skipped
  Storage Object block/storage1: Cannot set attribute pgr_support:
  [Errno 22] Invalid argument, skipped

Fix this warning by returning an error code only if we are really going to
flip the PGR/ALUA bit in the transport_flags field, otherwise we will do
nothing and return success.

Return ENOSYS instead of EINVAL if the pgr/alua attributes can not be
changed, this way it will be possible for userspace to understand if the
operation failed because an invalid value has been passed to strtobool() or
because the attributes are fixed.

Fixes: 356ba2a8bc8d ("scsi: target: tcmu: Make pgr_support and alua_support attributes writable")
Link: https://lore.kernel.org/r/20210906151809.52811-1-mlombard@redhat.com
Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_configfs.c | 32 +++++++++++++++++----------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 102ec644bc8a..023bd4516a68 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1110,20 +1110,24 @@ static ssize_t alua_support_store(struct config_item *item,
 {
 	struct se_dev_attrib *da = to_attrib(item);
 	struct se_device *dev = da->da_dev;
-	bool flag;
+	bool flag, oldflag;
 	int ret;
 
+	ret = strtobool(page, &flag);
+	if (ret < 0)
+		return ret;
+
+	oldflag = !(dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_ALUA);
+	if (flag == oldflag)
+		return count;
+
 	if (!(dev->transport->transport_flags_changeable &
 	      TRANSPORT_FLAG_PASSTHROUGH_ALUA)) {
 		pr_err("dev[%p]: Unable to change SE Device alua_support:"
 			" alua_support has fixed value\n", dev);
-		return -EINVAL;
+		return -ENOSYS;
 	}
 
-	ret = strtobool(page, &flag);
-	if (ret < 0)
-		return ret;
-
 	if (flag)
 		dev->transport_flags &= ~TRANSPORT_FLAG_PASSTHROUGH_ALUA;
 	else
@@ -1145,20 +1149,24 @@ static ssize_t pgr_support_store(struct config_item *item,
 {
 	struct se_dev_attrib *da = to_attrib(item);
 	struct se_device *dev = da->da_dev;
-	bool flag;
+	bool flag, oldflag;
 	int ret;
 
+	ret = strtobool(page, &flag);
+	if (ret < 0)
+		return ret;
+
+	oldflag = !(dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR);
+	if (flag == oldflag)
+		return count;
+
 	if (!(dev->transport->transport_flags_changeable &
 	      TRANSPORT_FLAG_PASSTHROUGH_PGR)) {
 		pr_err("dev[%p]: Unable to change SE Device pgr_support:"
 			" pgr_support has fixed value\n", dev);
-		return -EINVAL;
+		return -ENOSYS;
 	}
 
-	ret = strtobool(page, &flag);
-	if (ret < 0)
-		return ret;
-
 	if (flag)
 		dev->transport_flags &= ~TRANSPORT_FLAG_PASSTHROUGH_PGR;
 	else
-- 
2.33.0



