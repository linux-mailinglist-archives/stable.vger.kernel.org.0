Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC81105995
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 19:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbfKUScM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 13:32:12 -0500
Received: from a27-56.smtp-out.us-west-2.amazonses.com ([54.240.27.56]:38258
        "EHLO a27-56.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726293AbfKUScM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 13:32:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574361131;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=UZWfLHNZyjo0uxwd7HGUaUTR2svfAG+XtuRNNAaT300=;
        b=GP2f+3zMBdpTBBeNR1WATr6BqUVRtSmV7tgsRy4QEXFz6jkXTDbhaRgutLMi+Ht1
        zb1w/2/RdMgJ9qx48vch4K6M2IKlVLz1D9XSOykvof3xzIIfRqmI6p+yyx7EYepFtou
        NwvAJeqYfMfrv3BSbyrYf1XsIGrdWu7X1pTe01RI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574361131;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=UZWfLHNZyjo0uxwd7HGUaUTR2svfAG+XtuRNNAaT300=;
        b=f2H378RPRWUdlnU3vkDTGbjzRxggnhllWj2zF6HnfqxoY9rhYgIiZKBme3dqSxiF
        eFO02A+w0Tk0zVTdfj+g4s+pnasnFMOKV03LmiGBvV4vE+UNUsEmwPguTfXzqAPDhcq
        m335ppLW3s2JicL86x8IC2f12xOBdGVRf8uwj54w=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6000CC447A9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] iwlwifi: mvm: don't send the IWL_MVM_RXQ_NSSN_SYNC notif
 to Rx queues
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191120132628.30731-1-emmanuel.grumbach@intel.com>
References: <20191120132628.30731-1-emmanuel.grumbach@intel.com>
To:     Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc:     linux-wireless@vger.kernel.org, luciano.coelho@intel.com,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        stable@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-ID: <0101016e8f3c686f-049c8c20-4974-4fcd-a0bc-3081de94e65b-000000@us-west-2.amazonses.com>
Date:   Thu, 21 Nov 2019 18:32:11 +0000
X-SES-Outgoing: 2019.11.21-54.240.27.56
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Emmanuel Grumbach <emmanuel.grumbach@intel.com> wrote:

> The purpose of this was to keep all the queues updated with
> the Rx sequence numbers because unlikely yet possible
> situations where queues can't understand if a specific
> packet needs to be dropped or not.
> 
> Unfortunately, it was reported that this caused issues in
> our DMA engine. We don't fully understand how this is related,
> but this is being currently debugged. For now, just don't send
> this notification to the Rx queues. This de-facto reverts my
> commit 3c514bf831ac12356b695ff054bef641b9e99593:
> 
> iwlwifi: mvm: add a loose synchronization of the NSSN across Rx queues
> 
> This issue was reported here:
> https://bugzilla.kernel.org/show_bug.cgi?id=204873
> https://bugzilla.kernel.org/show_bug.cgi?id=205001
> and others maybe.
> 
> Fixes: 3c514bf831ac ("iwlwifi: mvm: add a loose synchronization of the NSSN across Rx queues")
> CC: <stable@vger.kernel.org> # 5.3+
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

New warning:

drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c: In function 'iwl_mvm_sync_nssn':
drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c:517:32: warning: unused variable 'notif' [-Wunused-variable]
  struct iwl_mvm_rss_sync_notif notif = {
                                ^~~~~

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/11253817/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

