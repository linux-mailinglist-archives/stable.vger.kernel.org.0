Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74AE45531C1
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 14:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbiFUMOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 08:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiFUMOC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 08:14:02 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 297311003;
        Tue, 21 Jun 2022 05:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=WnC8/sVEqcV82ARt6NQG9FTjINSGhbQW6PZRwnbLprs=; b=AAKg5CtcGYAQc9VOmfGncdP/qy
        6KjzYJBG9pPPuAL1pfNLPIvsq9t4K9dmbW045BGri0Pg98M4q4YD5Urjbxi00ARrcQQ+pMtoPGsr1
        V79EVcO1N6WvMsaAPEScCpL/a6qpOlcoBkhNuLZq11+sFCxHeZgB/emEqoCSGO9qnCkHgnHF4jO/g
        nWuBHSN91RpR76Ls6IjuajnytXDjwgOstNIFA+ZKxzpzwNotfWbYQk3VqBRuogPVPHyry3B51Lh4v
        CkNkjP+h6j/diRO+MYb6LHBMHIl/NvrufiWNDIx++xVJivhGSh64QsRA3qHpH0Klykj5d9Pk/wPHV
        xaPQ01H+09Z1834SWCS1go4rXN8Yb68Mk5B9ilJg6Lwu65bgrhCNFJDJl2eKoFDVTaz8/tPhCJzfD
        1OQXLchwjmRWMaBzFwMQR815ufEt282WjYZHJBz94QU/kTz4jgdcVUwAuLUIpYywATXqaC/6pLsXC
        dwgDAfVDgwYtTbViLcxMs2xZICitDOVDePPyqrwroF1VqiZScUZ1DJl3T/uLaix42zD65DfGiyR+L
        WIpfKcvqehqVpkzSM8r6AnmyTq7pilgFlioy12g4EImGmUrnTOHaFhZwjN1zcpWOto+4H+hFL4VjG
        lBMbs8eqfdeTKUOe7/qFLiqvRyDGKuW8NYEAHejrA=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        David Howells <dhowells@redhat.com>, stable@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] 9p: fix EBADF errors in cached mode
Date:   Tue, 21 Jun 2022 14:13:51 +0200
Message-ID: <25475559.V594D4LmdM@silver>
In-Reply-To: <YrDZ3nlTFwJ4ytl8@codewreck.org>
References: <15767273.MGizftpLG7@silver> <1902408.H94Nh90b8Q@silver>
 <YrDZ3nlTFwJ4ytl8@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Montag, 20. Juni 2022 22:34:38 CEST Dominique Martinet wrote:
> Christian Schoenebeck wrote on Mon, Jun 20, 2022 at 02:47:24PM +0200:
> > Some more tests this weekend; all looks fine. It appears that this also
> > fixed the performance degradation that I reported early in this thread.
> 
> wow, I wouldn't have expected the EBADF fix patch to have any impact on
> performance. Maybe the build just behaved differently enough to take
> more time with the errors?

Maybe. It could also be less overhead using writeback_fid vs. dedicated fid, 
i.e. no walking and fid cloning required when just using the writeback_fid 
which is already there (reduced latency).

Probably also overall reduced total amount of fids might have some (smaller) 
impact, as on QEMU 9p server side we still have a simple linked list for fids 
which is iterated on each fid lookup. A proc-like interface for statistics 
(e.g. max. amount of fids) would be useful.

But honestly, all these things still don't really explain to me such a 
difference from performance PoV in regards to this patch, as the particular 
case handled by this patch does not appear to happen often.

Anyway, my plan is to identify performance bottlenecks in general more 
analytically this year. Now that we have macOS support for 9p in QEMU, I'll 
probably use Xcode's "Instruments" tool which really has a great way to 
graphically investigate complex performance aspects in a very intuitive and 
customizable way, which goes beyond standard profiling. Then I can hunt down 
performance issues by weight.

Best regards,
Christian Schoenebeck


