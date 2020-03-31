Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AACEC199180
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730348AbgCaJPf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:15:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:35910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730754AbgCaJPe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:15:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39FDD2072E;
        Tue, 31 Mar 2020 09:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646133;
        bh=orhVSCEBXcC5KwzEYYjTBBxBvxGMor1crpLbKes0erU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iM/rlOBrvfDsC9/S8N+VA9X+L3uddC7oRkcCaVYB44kqLBM2r+6MJrz0qvtcgJjKW
         20Jnzb2lPItlJIbSjFDg+YzPeDQyIIS1nb2D2Qb59/gCL0lv5yjkNL7KXvmjCEuAgV
         D0EL+qt9EfYxtftfdR0sNCC8Q+ErNEqN2RrX5+jE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ashish <ashishkumar.yadav@students.iiserpune.ac.in>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.4 093/155] rtlwifi: rtl8188ee: Fix regression due to commit d1d1a96bdb44
Date:   Tue, 31 Mar 2020 10:58:53 +0200
Message-Id: <20200331085428.934608374@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>

commit c80b18cbb04b7b101af9bd14550f13d9866c646a upstream.

For some unexplained reason, commit d1d1a96bdb44 ("rtlwifi: rtl8188ee:
Remove local configuration variable") broke at least one system. As
the only net effect of the change was to remove 2 bytes from the start
of struct phy_status_rpt, this patch adds 2 bytes of padding at the
beginning of the struct.

Fixes: d1d1a96bdb44 ("rtlwifi: rtl8188ee: Remove local configuration variable")
Cc: Stable <stable@vger.kernel.org>  # V5.4+
Reported-by: Ashish <ashishkumar.yadav@students.iiserpune.ac.in>
Tested-by: Ashish <ashishkumar.yadav@students.iiserpune.ac.in>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.h |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.h
@@ -561,6 +561,7 @@ static inline void clear_pci_tx_desc_con
 	 rxmcs == DESC92C_RATE11M)
 
 struct phy_status_rpt {
+	u8	padding[2];
 	u8	ch_corr[2];
 	u8	cck_sig_qual_ofdm_pwdb_all;
 	u8	cck_agc_rpt_ofdm_cfosho_a;


