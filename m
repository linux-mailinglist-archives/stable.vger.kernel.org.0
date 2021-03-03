Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 888E932C827
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346688AbhCDAee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:34:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbhCCRY1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 12:24:27 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFF8C061756
        for <stable@vger.kernel.org>; Wed,  3 Mar 2021 09:23:37 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lHVDk-00030S-H7; Wed, 03 Mar 2021 18:23:36 +0100
Date:   Wed, 3 Mar 2021 18:23:36 +0100
From:   Florian Westphal <fw@strlen.de>
To:     stable@vger.kernel.org
Cc:     pablo@netfilter.org, paulburton@kernel.org
Subject: stable request: mips strncpy is broken
Message-ID: <20210303172336.GF17911@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

Please consider queueing

commit 3c0be5849259b729580c23549330973a2dd513a2
Author: Paul Burton <paulburton@kernel.org>
 MIPS: Drop 32-bit asm string functions

The commit is part of 5.5-rc1.

We got a bug report about following nftables rule not matching
even if it should on Linux 5.4.y mips32:

  meta iifname "br-vlan"

'iifname' uses strncpy(..., IFNAMSIZ) to copy dev->name to the register.
The MIPS asm function doesn't zero-pad the remaining bytes, but that is
needed for the compare op to work reliably.

The reporter confirmed that this removal fixes the issue, the generic C
version behaves as expected.

The patch doesn't apply cleanly to 5.4, there is a minor conflict
related to FORTIFY macro, but its easily resolved as all code
is removed.

I did not try earlier 4.4.y releases but I susepct they should also get
this patch applied.

I can send a 5.4.y backport if thats preferred.

Thanks.
