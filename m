Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDD02593BF
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730141AbgIAPaa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:30:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:60560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729759AbgIAPaX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:30:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 109E4206C0;
        Tue,  1 Sep 2020 15:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974222;
        bh=whkbtm8VN3E8r4nRvUNs2x9kFb8G9AFN0O5lxm10c/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VvzDsEdhv9PDAPh7pNAxtFFW9Xle207gbCNcqZhgLvYGUsSe/w7sGFJOnVqUqsT0V
         daE1sYEeIfksX7REyMHulFAmKaFAwEsZNWgXpFerntGLUIlEgNILlrjUCo6p8IRmno
         Meg928ydxG9nXL6uq0kJhxRCSHka8goGHB6f2ccI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 091/214] EDAC: skx_common: get rid of unused type var
Date:   Tue,  1 Sep 2020 17:09:31 +0200
Message-Id: <20200901150957.357136292@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

[ Upstream commit f05390d30e20cccd8f8de981dee42bcdd8d2d137 ]

	drivers/edac/skx_common.c: In function ‘skx_mce_output_error’:
	drivers/edac/skx_common.c:478:8: warning: variable ‘type’ set but not used [-Wunused-but-set-variable]
	  478 |  char *type, *optype;
	      |        ^~~~

Acked-by: Borislav Petkov <bp@alien8.de>
Acked-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/skx_common.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/edac/skx_common.c b/drivers/edac/skx_common.c
index 2177ad765bd16..4ca87723dcdcd 100644
--- a/drivers/edac/skx_common.c
+++ b/drivers/edac/skx_common.c
@@ -475,7 +475,7 @@ static void skx_mce_output_error(struct mem_ctl_info *mci,
 				 struct decoded_addr *res)
 {
 	enum hw_event_mc_err_type tp_event;
-	char *type, *optype;
+	char *optype;
 	bool ripv = GET_BITFIELD(m->mcgstatus, 0, 0);
 	bool overflow = GET_BITFIELD(m->status, 62, 62);
 	bool uncorrected_error = GET_BITFIELD(m->status, 61, 61);
@@ -490,14 +490,11 @@ static void skx_mce_output_error(struct mem_ctl_info *mci,
 	if (uncorrected_error) {
 		core_err_cnt = 1;
 		if (ripv) {
-			type = "FATAL";
 			tp_event = HW_EVENT_ERR_FATAL;
 		} else {
-			type = "NON_FATAL";
 			tp_event = HW_EVENT_ERR_UNCORRECTED;
 		}
 	} else {
-		type = "CORRECTED";
 		tp_event = HW_EVENT_ERR_CORRECTED;
 	}
 
-- 
2.25.1



