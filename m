Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 338A8388844
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 09:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240657AbhESHn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 03:43:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240620AbhESHn1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 May 2021 03:43:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3F5461353;
        Wed, 19 May 2021 07:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621410128;
        bh=vu5ThGta28LHz0+RO/abPJ60jEn1Pg++/iBmT2Fj+Cs=;
        h=From:To:Cc:Subject:Date:From;
        b=t6dL0Ha2TJkZOSuylhxZ/PKdcoJt2VI5FwlzJrRuTH4hwrarFuec9qbAKI6SRsQcr
         Q6VymvvLggdu51TXoHf8mkwrtvttjqpLPAD/nwUK8snU5XvS6H5XY7+YMgWZwBTVy+
         pkv94L2k2EVHSEWA0/IJbxNHHTKxHUDYK+XOv9KKMI++NAx5bs5oBx5Knjlxhh7FYy
         oubzvPuzQy1kXHsY0l4DDP0wAVX/otqlKZa8uwkqynNaj5MGD5M8+/Hwv47ZTwkEhA
         X9p0csY3+xOQTXyVFsiGu3Z+pJ4Qjvm97QglJnemHrwwoxLdBRhGtC0YpYJ9dBuTqh
         k2yxguidUj4fw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     stable@vger.kernel.org
Cc:     snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH stable] dm ioctl: fix out of bounds array access when no devices
Date:   Wed, 19 May 2021 09:41:24 +0200
Message-Id: <20210519074124.49890-1-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 4edbe1d7bcffcd6269f3b5eb63f710393ff2ec7a upstream.

If there are not any dm devices, we need to zero the "dev" argument in
the first structure dm_name_list. However, this can cause out of
bounds write, because the "needed" variable is zero and len may be
less than eight.

Fix this bug by reporting DM_BUFFER_FULL_FLAG if the result buffer is
too small to hold the "nl->dev" value.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
Please apply to 4.4.y and 4.9.y

 drivers/md/dm-ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 836a2808c0c7..eb2659a12310 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -524,7 +524,7 @@ static int list_devices(struct dm_ioctl *param, size_t param_size)
 	 * Grab our output buffer.
 	 */
 	nl = get_result_buffer(param, param_size, &len);
-	if (len < needed) {
+	if (len < needed || len < sizeof(nl->dev)) {
 		param->flags |= DM_BUFFER_FULL_FLAG;
 		goto out;
 	}
-- 
2.20.1

