Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB55C32C4C
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbfFCJMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:12:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728652AbfFCJMm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:12:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28AB021923;
        Mon,  3 Jun 2019 09:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559553161;
        bh=JLQiK3KSKpVQgTR2lodTLdBwhQ6GWgllLMuFRDm5qAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bd0M/0eRFJpC6joastPooCMYasKl++Y3lOkostayWAxxIkdkVuqJBmbLxSNcOHFxo
         D9GFPB4tP+q/4dhRzl5V/eV+sjq3y8haOOTnHcMeOPW1GUpg8oWa39+aG63xfHoqLA
         DbZNCx54m4mkIfqycg1ddWUnY1az8b4RHCYlq3QQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vishal Kulkarni <vishal@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 31/36] cxgb4: Revert "cxgb4: Remove SGE_HOST_PAGE_SIZE dependency on page size"
Date:   Mon,  3 Jun 2019 11:09:19 +0200
Message-Id: <20190603090523.044809798@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603090520.998342694@linuxfoundation.org>
References: <20190603090520.998342694@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vishal Kulkarni <vishal@chelsio.com>

[ Upstream commit ab0610efabb4c4f419a531455708caf1dd29357e ]

This reverts commit 2391b0030e241386d710df10e53e2cfc3c5d4fc1 which has
introduced regression. Now SGE's BAR2 Doorbell/GTS Page Size is
interpreted correctly in the firmware itself by using actual host
page size. Hence previous commit needs to be reverted.

Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -7139,10 +7139,21 @@ int t4_fixup_host_params(struct adapter
 			 unsigned int cache_line_size)
 {
 	unsigned int page_shift = fls(page_size) - 1;
+	unsigned int sge_hps = page_shift - 10;
 	unsigned int stat_len = cache_line_size > 64 ? 128 : 64;
 	unsigned int fl_align = cache_line_size < 32 ? 32 : cache_line_size;
 	unsigned int fl_align_log = fls(fl_align) - 1;
 
+	t4_write_reg(adap, SGE_HOST_PAGE_SIZE_A,
+		     HOSTPAGESIZEPF0_V(sge_hps) |
+		     HOSTPAGESIZEPF1_V(sge_hps) |
+		     HOSTPAGESIZEPF2_V(sge_hps) |
+		     HOSTPAGESIZEPF3_V(sge_hps) |
+		     HOSTPAGESIZEPF4_V(sge_hps) |
+		     HOSTPAGESIZEPF5_V(sge_hps) |
+		     HOSTPAGESIZEPF6_V(sge_hps) |
+		     HOSTPAGESIZEPF7_V(sge_hps));
+
 	if (is_t4(adap->params.chip)) {
 		t4_set_reg_field(adap, SGE_CONTROL_A,
 				 INGPADBOUNDARY_V(INGPADBOUNDARY_M) |


