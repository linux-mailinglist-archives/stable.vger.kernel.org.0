Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D37429063
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238286AbhJKOHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:07:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:56462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238214AbhJKOFk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:05:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A0CC60F35;
        Mon, 11 Oct 2021 13:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960795;
        bh=KatlpQaVe2Tnj8+hKldMj+ZI/hitDdpstM/2v3SlcLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FxLjYP+JhgpgP/5fujnopGtocmJFKcvL/yQxEEQ7bzSFHSsnsxF4Sn2nOHds0hBU5
         pPo1RuOe+p/rGQNvAxvs2ZqtBefusCgsHcUf3LA5uySjxXyNGJ/UZ7hgGi3mN72+Vu
         OrmlUtl6e5Jk9SzifZdhepuWjMYLYhmzQFWzbCsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 042/151] soc: qcom: mdt_loader: Drop PT_LOAD check on hash segment
Date:   Mon, 11 Oct 2021 15:45:14 +0200
Message-Id: <20211011134519.213747184@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shawn Guo <shawn.guo@linaro.org>

[ Upstream commit 833d51d7c66d6708abbc02398892b96b950167b9 ]

PT_LOAD type denotes that the segment should be loaded into the final
firmware memory region.  Hash segment is not one such, because it's only
needed for PAS init and shouldn't be in the final firmware memory region.
That's why mdt_phdr_valid() explicitly reject non PT_LOAD segment and
hash segment.  This actually makes the hash segment type check in
qcom_mdt_read_metadata() unnecessary and redundant.  For a hash segment,
it won't be loaded into firmware memory region anyway, due to the
QCOM_MDT_TYPE_HASH check in mdt_phdr_valid(), even if it has a PT_LOAD
type for some reason (misusing or abusing?).

Some firmware files on Sony phones are such examples, e.g WCNSS firmware
of Sony Xperia M4 Aqua phone.  The type of hash segment is just PT_LOAD.
Drop the unnecessary hash segment type check in qcom_mdt_read_metadata()
to fix firmware loading failure on these phones, while hash segment is
still kept away from the final firmware memory region.

Fixes: 498b98e93900 ("soc: qcom: mdt_loader: Support loading non-split images")
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210828070202.7033-1-shawn.guo@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/mdt_loader.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/mdt_loader.c b/drivers/soc/qcom/mdt_loader.c
index eba7f76f9d61..6034cd8992b0 100644
--- a/drivers/soc/qcom/mdt_loader.c
+++ b/drivers/soc/qcom/mdt_loader.c
@@ -98,7 +98,7 @@ void *qcom_mdt_read_metadata(const struct firmware *fw, size_t *data_len)
 	if (ehdr->e_phnum < 2)
 		return ERR_PTR(-EINVAL);
 
-	if (phdrs[0].p_type == PT_LOAD || phdrs[1].p_type == PT_LOAD)
+	if (phdrs[0].p_type == PT_LOAD)
 		return ERR_PTR(-EINVAL);
 
 	if ((phdrs[1].p_flags & QCOM_MDT_TYPE_MASK) != QCOM_MDT_TYPE_HASH)
-- 
2.33.0



