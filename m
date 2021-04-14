Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E2D35F347
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 14:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346687AbhDNMPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 08:15:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232338AbhDNMPD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Apr 2021 08:15:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A25A6105A;
        Wed, 14 Apr 2021 12:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618402481;
        bh=YiabDS3/jUfuh8TT2QSI1OG4Od9EmNsYJXGvHAlYiss=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C/Os0pNE9eiJYt1g2Dkn9Oi2/8bW3yZ351I0lQY4rz1eKQl1MtdWuBm4d5EKSm1mq
         NV5ZrDbVuJibAaXrXVeTQBFZzotHsKvWUwrvJ/KIPZGfqKOcsneymCZ/Si+Xievqiq
         6InR65iZjGI7l9yyIX/IWZMmK+DVdQdW2yYhLcTcseP7ZddrEq9ts1GEzWsXIXUNP1
         lOYCO1VvGhsOzoMZogbL3JQUQgoxNRLAbdpNKtU1m5vu2FFKQrm8Yx4PcDpX/d/iRg
         fkbRPQsrTrpoZW2mRvNAEYa7YvGDNcL9ObUe4bOvp9eomG53N4HnPbPRsgN2bEJeIa
         NYOMQpz3del6A==
Date:   Wed, 14 Apr 2021 08:14:40 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Gulam Mohamed <gulam.mohamed@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 07/22] scsi: iscsi: Fix race condition
 between login and sync thread
Message-ID: <YHbcsA22Ag3o4QAZ@sashalap>
References: <20210405160432.268374-1-sashal@kernel.org>
 <20210405160432.268374-7-sashal@kernel.org>
 <be0783c0-4ca8-d7fd-ce97-c24c2f1d8e84@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <be0783c0-4ca8-d7fd-ce97-c24c2f1d8e84@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 06, 2021 at 12:24:32PM -0500, Mike Christie wrote:
>On 4/5/21 11:04 AM, Sasha Levin wrote:
>> From: Gulam Mohamed <gulam.mohamed@oracle.com>
>>
>> [ Upstream commit 9e67600ed6b8565da4b85698ec659b5879a6c1c6 ]
>>
>> A kernel panic was observed due to a timing issue between the sync thread
>> and the initiator processing a login response from the target. The session
>> reopen can be invoked both from the session sync thread when iscsid
>> restarts and from iscsid through the error handler. Before the initiator
>> receives the response to a login, another reopen request can be sent from
>> the error handler/sync session. When the initial login response is
>> subsequently processed, the connection has been closed and the socket has
>> been released.
>>
>> To fix this a new connection state, ISCSI_CONN_BOUND, is added:
>>
>>  - Set the connection state value to ISCSI_CONN_DOWN upon
>>    iscsi_if_ep_disconnect() and iscsi_if_stop_conn()
>>
>>  - Set the connection state to the newly created value ISCSI_CONN_BOUND
>>    after bind connection (transport->bind_conn())
>>
>>  - In iscsi_set_param(), return -ENOTCONN if the connection state is not
>>    either ISCSI_CONN_BOUND or ISCSI_CONN_UP
>>
>> Link: https://urldefense.com/v3/__https://lore.kernel.org/r/20210325093248.284678-1-gulam.mohamed@oracle.com__;!!GqivPVa7Brio!Jiqrc6pu3EgrquzpG-KpNQkNebwKUgctkE0MN1MloQ2y5Y4OVOkKN0yCr2_W_CX2oRet$
>> Reviewed-by: Mike Christie <michael.christie@oracle.com>
>
>
>There was a mistake in my review of this patch. It will also require
>this "[PATCH 1/1] scsi: iscsi: fix iscsi cls conn state":
>
>https://lore.kernel.org/linux-scsi/20210406171746.5016-1-michael.christie@oracle.com/T/#u

As the fix isn't upstream yet, I'll drop 9e67600ed6b for now and
re-queue it for the next round. Thanks!

-- 
Thanks,
Sasha
