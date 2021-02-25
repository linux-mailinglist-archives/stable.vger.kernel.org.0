Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5944324A65
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 07:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhBYGIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 01:08:31 -0500
Received: from mo-csw1116.securemx.jp ([210.130.202.158]:42432 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235268AbhBYGHT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 01:07:19 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1116) id 11P64puQ011283; Thu, 25 Feb 2021 15:04:51 +0900
X-Iguazu-Qid: 2wGqzdZmdYxMsWacDZ
X-Iguazu-QSIG: v=2; s=0; t=1614233091; q=2wGqzdZmdYxMsWacDZ; m=fCyXxvB60ezjAlgzby/zURou/Yw/+qDszJJYTl9GSwE=
Received: from imx2-a.toshiba.co.jp (imx2-a.toshiba.co.jp [106.186.93.35])
        by relay.securemx.jp (mx-mr1111) id 11P64oU5003934
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 25 Feb 2021 15:04:50 +0900
Received: from enc01.toshiba.co.jp (enc01.toshiba.co.jp [106.186.93.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by imx2-a.toshiba.co.jp (Postfix) with ESMTPS id EA3D71000D4;
        Thu, 25 Feb 2021 15:04:49 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.toshiba.co.jp  with ESMTP id 11P64nT3000776;
        Thu, 25 Feb 2021 15:04:49 +0900
Date:   Thu, 25 Feb 2021 15:04:46 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.4 04/35] iwlwifi: pcie: add a NULL check in
 iwl_pcie_txq_unmap
X-TSB-HOP: ON
Message-ID: <20210225060446.auoymjxg5cuzlism@toshiba.co.jp>
References: <20210222121013.581198717@linuxfoundation.org>
 <20210222121017.933649049@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222121017.933649049@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Sorry for the report after the release.

On Mon, Feb 22, 2021 at 01:36:00PM +0100, Greg Kroah-Hartman wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> 
> [ Upstream commit 98c7d21f957b10d9c07a3a60a3a5a8f326a197e5 ]
> 
> I hit a NULL pointer exception in this function when the
> init flow went really bad.
> 
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> Link: https://lore.kernel.org/r/iwlwifi.20210115130252.2e8da9f2c132.I0234d4b8ddaf70aaa5028a20c863255e05bc1f84@changeid
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/wireless/iwlwifi/pcie/tx.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
> index 8dfe6b2bc7031..cb03c2855019b 100644
> --- a/drivers/net/wireless/iwlwifi/pcie/tx.c
> +++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
> @@ -585,6 +585,11 @@ static void iwl_pcie_txq_unmap(struct iwl_trans *trans, int txq_id)
>  	struct iwl_txq *txq = &trans_pcie->txq[txq_id];
>  	struct iwl_queue *q = &txq->q;
>  
> +	if (!txq) {
> +		IWL_ERR(trans, "Trying to free a queue that wasn't allocated?\n");
> +		return;
> +	}
> +

I think that this fix is not enough.
If txq is NULL, an error will occur with "struct iwl_queue * q = & txq->q;".
The following changes are required.

diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index cb03c2855019b7..7584796131fa41 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -583,13 +583,15 @@ static void iwl_pcie_txq_unmap(struct iwl_trans *trans, int txq_id)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_txq *txq = &trans_pcie->txq[txq_id];
-	struct iwl_queue *q = &txq->q;
+	struct iwl_queue *q;
 
 	if (!txq) {
 		IWL_ERR(trans, "Trying to free a queue that wasn't allocated?\n");
 		return;
 	}
 
+	q = &txq->q;
+
 	spin_lock_bh(&txq->lock);
 	while (q->write_ptr != q->read_ptr) {
 		IWL_DEBUG_TX_REPLY(trans, "Q %d Free %d\n",



>  	spin_lock_bh(&txq->lock);
>  	while (q->write_ptr != q->read_ptr) {
>  		IWL_DEBUG_TX_REPLY(trans, "Q %d Free %d\n",
> -- 
> 2.27.0
> 
> 

Best regards,
  Nobuhiro
