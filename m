Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2334A26183A
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732120AbgIHRuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:50:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57345 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731620AbgIHQN6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:13:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1212248EC;
        Tue,  8 Sep 2020 15:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580386;
        bh=Zig6pt54X9QJzeAL3Cyy+Jyt3go3+KPnQI8g9MuFpeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Irt5sorqhJPzMEnz1mCSZLDA66CXcPXCcpgbtbwMNdGrMMW7d9JSRXN+JtRa20wEK
         5SnSrG1ryf6R2mkqz//webtLJpm0c5yfduQiedPwS7/o+K7UWQrUiK7YnwPLfsqo2o
         aHhAGa10fbPeLbRkhfdflVS7uGzBQHeFuNBWnf0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ye Bin <yebin10@huawei.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.14 56/65] dm thin metadata:  Avoid returning cmd->bm wild pointer on error
Date:   Tue,  8 Sep 2020 17:26:41 +0200
Message-Id: <20200908152219.983464761@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152217.022816723@linuxfoundation.org>
References: <20200908152217.022816723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

commit 219403d7e56f9b716ad80ab87db85d29547ee73e upstream.

Maybe __create_persistent_data_objects() caller will use PTR_ERR as a
pointer, it will lead to some strange things.

Signed-off-by: Ye Bin <yebin10@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-thin-metadata.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -698,12 +698,16 @@ static int __create_persistent_data_obje
 					  THIN_MAX_CONCURRENT_LOCKS);
 	if (IS_ERR(pmd->bm)) {
 		DMERR("could not create block manager");
-		return PTR_ERR(pmd->bm);
+		r = PTR_ERR(pmd->bm);
+		pmd->bm = NULL;
+		return r;
 	}
 
 	r = __open_or_format_metadata(pmd, format_device);
-	if (r)
+	if (r) {
 		dm_block_manager_destroy(pmd->bm);
+		pmd->bm = NULL;
+	}
 
 	return r;
 }


