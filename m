Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD433787F5
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238824AbhEJLUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:20:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236068AbhEJLH0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:07:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF48C6188B;
        Mon, 10 May 2021 10:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644284;
        bh=kSrKgO2xaqO6lOznFu5zbp+aAYubKCef7sgvh9D3tSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YWYJLkKj6KpcoGyQwPVCIdFRMmvTApnh4xUdSgmpuH3WWmHoBZgIB4ztFe0bIPj94
         +m8DQn/CBWhjZJ0SSMDfw+FDgy5mNzt/Jag/FuSrtx6jpnAxX22kxWnnn/gxO65e55
         UW19++Uv5Y+mGxmiHd9A/tiJvmLtrX7PHjSR5dNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Hemant Kumar <hemantk@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 5.12 002/384] bus: mhi: core: Clear configuration from channel context during reset
Date:   Mon, 10 May 2021 12:16:31 +0200
Message-Id: <20210510102014.934800796@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bhaumik Bhatt <bbhatt@codeaurora.org>

commit 47705c08465931923e2f2b506986ca0bdf80380d upstream.

When clearing up the channel context after client drivers are
done using channels, the configuration is currently not being
reset entirely. Ensure this is done to appropriately handle
issues where clients unaware of the context state end up calling
functions which expect a context.

Signed-off-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
Reviewed-by: Hemant Kumar <hemantk@codeaurora.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/1617311778-1254-7-git-send-email-bbhatt@codeaurora.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/core/init.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/bus/mhi/core/init.c
+++ b/drivers/bus/mhi/core/init.c
@@ -552,6 +552,7 @@ void mhi_deinit_chan_ctxt(struct mhi_con
 	struct mhi_ring *buf_ring;
 	struct mhi_ring *tre_ring;
 	struct mhi_chan_ctxt *chan_ctxt;
+	u32 tmp;
 
 	buf_ring = &mhi_chan->buf_ring;
 	tre_ring = &mhi_chan->tre_ring;
@@ -565,7 +566,19 @@ void mhi_deinit_chan_ctxt(struct mhi_con
 	vfree(buf_ring->base);
 
 	buf_ring->base = tre_ring->base = NULL;
+	tre_ring->ctxt_wp = NULL;
 	chan_ctxt->rbase = 0;
+	chan_ctxt->rlen = 0;
+	chan_ctxt->rp = 0;
+	chan_ctxt->wp = 0;
+
+	tmp = chan_ctxt->chcfg;
+	tmp &= ~CHAN_CTX_CHSTATE_MASK;
+	tmp |= (MHI_CH_STATE_DISABLED << CHAN_CTX_CHSTATE_SHIFT);
+	chan_ctxt->chcfg = tmp;
+
+	/* Update to all cores */
+	smp_wmb();
 }
 
 int mhi_init_chan_ctxt(struct mhi_controller *mhi_cntrl,


