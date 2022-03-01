Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A03934C906F
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 17:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233887AbiCAQeq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 11:34:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234154AbiCAQep (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 11:34:45 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0F962CCB3
        for <stable@vger.kernel.org>; Tue,  1 Mar 2022 08:34:03 -0800 (PST)
Received: from [192.168.1.214] (dynamic-089-012-174-087.89.12.pool.telefonica.de [89.12.174.87])
        by linux.microsoft.com (Postfix) with ESMTPSA id EBE0220B7178;
        Tue,  1 Mar 2022 08:34:02 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EBE0220B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1646152443;
        bh=9gVVHom3+DRfhrHetgZ/KWjL7lsVEuxXuJ+zve1LxjI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=IRnTd3LGHdl+tvcHTtBMUoqkz0o2vMFURBMDnZ3TD/Z155TXRxGX+XPqWgl4yRY5H
         hKDPsYVPK3HRlhhwGFS62Fbwql8g6BS6i7/1lp2yxYjhRJSYs8ZtAUMmdY+aOmVEQQ
         oiBhbYoUzKb2FcEWhUkcFJO6I5tEZcssN+tkNycQ=
Subject: Re: xfrm regression in 5.10.94
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <e2e9e487-1efb-783f-ca5b-7d0c88f8de7b@linux.microsoft.com>
 <Yh0Db4AJA0QBZ3iN@kroah.com>
From:   Kai Lueke <kailueke@linux.microsoft.com>
Message-ID: <e8d57c20-56f8-f457-1db5-e6d5ed9618b6@linux.microsoft.com>
Date:   Tue, 1 Mar 2022 17:34:00 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <Yh0Db4AJA0QBZ3iN@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,
> Why is 5.10 special and newer kernels are not?  This change shows up for
> them, right?  Either this is a regression for all kernel releases and
> needs to be resolved, or it is ok for any kernel release.
>
> Please work with the networking developers to either resolve the
> regression of determine what needs to be done here for userspace to work
> properly.

I agree, thanks. I tried it
(https://marc.info/?t=164607426900002&r=1&w=2) and got this response
from Steffen Klassert now:

> In general I agree that the userspace ABI has to be stable, but
> this never worked. We changed the behaviour from silently broken to
> notify userspace about a misconfiguration.
>
> It is the question what is more annoying for the users. A bug that
> we can never fix, or changing a broken behaviour to something that
> tells you at least why it is not working.
>
> In such a case we should gauge what's the better solution. Here
> I tend to keep it as it is.
(https://marc.info/?l=linux-netdev&m=164615098503579&w=2)

Given it's unlikely to have this reverted in general I personally think
that reverting for the LTS kernels makes sense at least...

Regards,
Kai

