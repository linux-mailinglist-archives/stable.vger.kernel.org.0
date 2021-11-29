Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775514620B9
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 20:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351853AbhK2Tpn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 14:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239907AbhK2Tnk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 14:43:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F736C0698C0;
        Mon, 29 Nov 2021 08:01:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D60E61536;
        Mon, 29 Nov 2021 16:01:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4EDCC53FCB;
        Mon, 29 Nov 2021 16:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638201689;
        bh=Kv6MBJXYeHo0IxkIpDY6gwYHS2TLFxXrBu9ZJWu8kyc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HIUMWJn5i/ZkPEx2uv6ITIpHeBvPAEUJfIJWXd9m0bj0hSSR5mEDTX3OqcLtzzV1A
         VGyL4y2zK5MTat1iGPwpQ4bylq9ZcdfIblhCGEJt8EDu7Vwci/CWwM6/qZqrK8Bxfc
         jLKw2VgdNKPfMIp0PpkNcd4fnBnxdALIdbBoGNn8wKQRp0BuGtCQc8tSbIjo8FAecg
         plAAemFtuTDREl7q+APVmry/1jfQTJPC5UIFUHa4Hnmkc0Oc0QLx+3tEiVA65tbBsa
         9bNfCX/dSo3ieKAm9Kle4XQIul8QjWQYAftLs6WQlGUqHI9tLv/XM+3dOBuDbgRh0H
         ZZkEN9ot/hNxA==
Message-ID: <0e6e66f7368621128a810bb604eab229dd279187.camel@kernel.org>
Subject: Re: Commit f980d055a0f858d73d9467bb0b570721bbfcdfb8 causes a
 regression
From:   Jeff Layton <jlayton@kernel.org>
To:     Tim Gardner <tim.gardner@canonical.com>, len.baker@gmx.com
Cc:     pc@cjr.nz, stfrench@microsoft.com,
        Kamal Mostafa <Kamal.Mostafa@canonical.com>,
        linux-cifs@vger.kernel.org,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Date:   Mon, 29 Nov 2021 11:01:27 -0500
In-Reply-To: <a8b2287b-c459-2169-fbf4-31f3065e0897@canonical.com>
References: <a8b2287b-c459-2169-fbf4-31f3065e0897@canonical.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2021-11-29 at 08:35 -0700, Tim Gardner wrote:
> Hi Len,
> 
> I have a report (https://bugs.launchpad.net/bugs/1952094) that commit 
> f980d055a0f858d73d9467bb0b570721bbfcdfb8 ("CIFS: Fix a potencially 
> linear read overflow") causes a regression as a stable backport in a 5.4 
> based kernel. I don't know if this regression exists in tip as well, or 
> if it is unique to the backported environment. I suspect, given the 
> content of the patch, that it is generic. As such, it has been 
> backported to a number of stable releases:
> 
> linux-4.4.y.txt:0955df2d9bf4857e3e2287e3028903e6cec06c30
> linux-4.9.y.txt:8878af780747f498551b7d360cae61b415798f18
> linux-4.14.y.txt:20967547ffc6039f17c63a1c24eb779ee166b245
> linux-4.19.y.txt:bea655491daf39f1934a71bf576bf3499092d3a4
> linux-5.4.y.txt:b444064a0e0ef64491b8739a9ae05a952b5f8974
> linux-5.10.y.txt:6c4857203ffa36918136756a889b12c5864bc4ad
> linux-5.13.y.txt:9bffe470e9b537075345406512df01ca2188b725
> linux-5.14.y.txt:c41dd61c86482ab34f6f039b13296308018fd99b
> 
> Could this be an off-by-one issue if the source string is full length ?
> 
> rtg

Maybe? But it doesn't seem to be that long. The error message evidently
says:

    "CIFS VFS: CIFS mount error: iocharset utf8 not found"

The iocharset string ("utf8" here) usually gets set in the mount string
and then we just pass that string to load_nls().

The patch you're pointing out though doesn't seem to be involved in any
of that. It sounds like something else is wrong. I'd validate that that
patch was applied correctly, and get more details about what this guy is
doing.

g/l!
-- 
Jeff Layton <jlayton@kernel.org>
