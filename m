Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D54F913ACBD
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 15:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728755AbgANO5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 09:57:04 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:27121 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725904AbgANO5E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 09:57:04 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1579013824; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=/wDQzX9drwe6MnLxKEd1wgdmQ0ROFJy34Icy9JXF50Q=; b=mCFVjMMLOkJjVieBWS00YukNNyVXqDv4E4pVpljdbctxbFkJz/k647JDFEB1TXVqB1dEHrOF
 +5EtBZEPV1Mn8+BM1diBbYJCCvcy74ZIMfspusmrHlqS1beW/hM1+IH+Tue06MdsyelH+/HT
 xuqxYIWL01Vc0kiRxBTUM+Vhe3o=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e1dd6be.7fba760c6f48-smtp-out-n01;
 Tue, 14 Jan 2020 14:57:02 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 655D2C4479F; Tue, 14 Jan 2020 14:57:01 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2370AC43383;
        Tue, 14 Jan 2020 14:56:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2370AC43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        stable <stable@vger.kernel.org>, huangwen <huangwenabc@gmail.com>
Subject: Re: [PATCH] mwifiex: fix unbalanced locking in mwifiex_process_country_ie()
References: <20200106224212.189763-1-briannorris@chromium.org>
        <CA+ASDXNN5=97nhN99rPneLGSQAmQ4ULS6Kim1oxCzKWNtPkWFw@mail.gmail.com>
Date:   Tue, 14 Jan 2020 16:56:54 +0200
In-Reply-To: <CA+ASDXNN5=97nhN99rPneLGSQAmQ4ULS6Kim1oxCzKWNtPkWFw@mail.gmail.com>
        (Brian Norris's message of "Mon, 6 Jan 2020 14:51:02 -0800")
Message-ID: <87imle13yh.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Brian Norris <briannorris@chromium.org> writes:

> On Mon, Jan 6, 2020 at 2:43 PM Brian Norris <briannorris@chromium.org> wrote:
>>
>> We called rcu_read_lock(), so we need to call rcu_read_unlock() before
>> we return.
>>
>> Fixes: 3d94a4a8373b ("mwifiex: fix possible heap overflow in mwifiex_process_country_ie()")
>> Cc: stable@vger.kernel.org
>> Cc: huangwen <huangwenabc@gmail.com>
>> Cc: Ganapathi Bhat <ganapathi.bhat@nxp.com>
>> Signed-off-by: Brian Norris <briannorris@chromium.org>
>
> I probably should have mentioned somewhere here: the bug is currently
> in 5.5-rc and is being ported to -stable already (I'll try to head
> that off). So this probably should have said [PATCH 5.5]. Sorry about
> that.

Ok, I'll queue this to v5.5.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
