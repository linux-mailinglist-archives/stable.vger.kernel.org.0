Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1689419AEA
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236045AbhI0ROj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:14:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236595AbhI0RMQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:12:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D53B361074;
        Mon, 27 Sep 2021 17:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762522;
        bh=HmNex+zEz8gkDUvyvy01N4hkjfnuv/eUBBlDfxH0oHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTvRRKEm9GA/pLtjpG0WANrRx8FfwBsHJJiTO8hlY8jVs+3SZzNSPQ2lUD2TXN52+
         GEh5ecelJOcDNk7kCgAYizCJUED5pHHkHo0Uei/OYdWkWWGC6XdK87T5O/fmwE782E
         X2Hr9HfZDoGosX6UsMoH190YNWPJ8oG5SDfYnOzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bodo Stroesser <bostroesser@gmail.com>,
        Maurizio Lombardi <mlombard@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/103] scsi: target: Fix the pgr/alua_support_store functions
Date:   Mon, 27 Sep 2021 19:02:26 +0200
Message-Id: <20210927170227.635403139@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
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
index f04352285155..56ae882fb7b3 100644
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



