Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA814599795
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 10:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347775AbiHSIrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 04:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347777AbiHSIro (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 04:47:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67470C742B;
        Fri, 19 Aug 2022 01:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=2CIlI/i5kD70ZhhKElCJYvXGuqpWEWdE1++gdn9VbW0=; b=tfhbFzGRx9RcV9+M5J1fzQqkBz
        Bu+oCUN2G873DxjDAtlBbJ/u0kMkATMtBmaC3aslVEP74JiTKwsNU2lIiIcfNvBlH9o2xtwuhhqcQ
        Ro9H4Msh/gddudHnpwUKVSdChFHY2g8DPiOLGMpAit1FECqs1f3VTQthLKRoy9Ac9z7of2WRtpVEu
        Z04eA5ph88ab+DbumJqaLA0t8cvoRUPKXZNViPCcWhlFSKlvfGPR0mHx6SGxRAgXMyN+kjH3UDvvC
        En0jKbNh5sMbIDewsLITXO4P4fmWLftzhR5vDnW7qkC0ewMSkLvCPZeZ7XqkAf3oIj0v2gpLogMYw
        xcUeeaJA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oOxf0-00Avoi-TY; Fri, 19 Aug 2022 08:47:23 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id E157C980120; Fri, 19 Aug 2022 10:47:21 +0200 (CEST)
Date:   Fri, 19 Aug 2022 10:47:21 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        1017425@bugs.debian.org,
        =?iso-8859-1?Q?Martin-=C9ric?= Racine <martin-eric.racine@iki.fi>,
        stable@vger.kernel.org, regressions@lists.linux.dev,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: Re: [PATCH] x86/speculation: Avoid LFENCE in FILL_RETURN_BUFFER on
 CPUs that lack it
Message-ID: <Yv9OGVc+WpoDAB0X@worktop.programming.kicks-ass.net>
References: <Yv7aRJ/SvVhSdnSB@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <Yv7aRJ/SvVhSdnSB@decadent.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 19, 2022 at 02:33:08AM +0200, Ben Hutchings wrote:
> From: Ben Hutchings <benh@debian.org>
>=20
> The mitigation for PBRSB includes adding LFENCE instructions to the
> RSB filling sequence.  However, RSB filling is done on some older CPUs
> that don't support the LFENCE instruction.
>=20

Wait; what? There are chips that enable the RSB mitigations and DONT
have LFENCE ?!?
