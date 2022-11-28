Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04B4F63B4CF
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 23:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbiK1W2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 17:28:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233660AbiK1W2M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 17:28:12 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80EA24B;
        Mon, 28 Nov 2022 14:28:10 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 2ASMS3cc017750
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 17:28:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1669674485; bh=93sV9uF9firD2I2yjs8f7J69JyRyRKxsZzFKTMgpo+Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=pwBmEyO3XgD1rsAnMLjxB8wVG7geyPSPxRrNfE517cO/ImMwSo8wZc5Ca/oUVIKTw
         5Y0AAlgYv43YPCIDnPmLu8I+FGroQijVrpq6VG0mhr75lgbLLQHtQGCdoaUihSrls5
         KGU8CxwwRLVaQoqwhdG66gZDhdRE5Uh48aIjOt3HhVQwwkiatU8LGRfViX0l8QCyGy
         ELbAawK9dCLowX8lMWiyMCDRb2Dpr3MsJqB8ufcGF3I01tjF1eBB8G1NNjVdU0AwNg
         rUlYXFM8/NPONr+zJW0McAH49cZYiR/STAXsWRDpPhTN7RO7uMsIoC1jxkY+qjoW/m
         2dhe0FDZ4Uypg==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 42D2615C3AA6; Mon, 28 Nov 2022 17:28:03 -0500 (EST)
Date:   Mon, 28 Nov 2022 17:28:03 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] ext4: fix a NULL pointer when validating an inode
 bitmap
Message-ID: <Y4U18wly7K87fX9v@mit.edu>
References: <20221010142035.2051-1-lhenriques@suse.de>
 <20221011155623.14840-1-lhenriques@suse.de>
 <Y2cAiLNIIJhm4goP@mit.edu>
 <Y2piZT22QwSjNso9@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y2piZT22QwSjNso9@suse.de>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 08, 2022 at 02:06:29PM +0000, Luís Henriques wrote:
> > What makes you believe that?  Look at how s_group_info is initialized
> > in ext4_mb_alloc_groupinfo() in fs/ext4/mballoc.c.  It's pretty
> > careful to make sure this is not the case.
> 
> Right.  I may be missing something, but I don't think we get that far.
> __ext4_fill_super() will first call ext4_setup_system_zone() (which is
> where this bug occurs) and only after that ext4_mb_init() will be invoked
> (which is where ext4_mb_alloc_groupinfo() will eventually be called).

I finally got around to taking a closer look at this, and I have a
much better understandign of what is going on.  For more details, and
a suggested fix, please see:

     https://bugzilla.kernel.org/show_bug.cgi?id=216541#c1

						- Ted
