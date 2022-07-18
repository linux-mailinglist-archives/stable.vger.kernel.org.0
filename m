Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA99578708
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 18:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233295AbiGRQLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 12:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234831AbiGRQLA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 12:11:00 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D24D29CB5;
        Mon, 18 Jul 2022 09:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+crDeFSf2FINyOliJvGzyzWKrsaftXMw2kMu2ZNWhMs=; b=ulCadODE5fRHDcGeQY3qDQAwpT
        8ekvnrFu2RKqzUugYSjyMGS6KL/j+ihhEmgvoT7oPi5Zfnxe9Dg64lTD3LY+E6qdP1TZQ44rqSZD8
        SHa2Jq8QSL79uY0AKri4CS7hF8unKOSh7nCEyqMr+JDtrOl/N7D30qN/s2xc9bl+wdCW2lOuEITKw
        qQjt8hRQHJ6yu0YCRJsSdSFZULucdTaZ09QB8eUdmaPNNhjfWAfBKUObUPxYEjXvwWKlkXmWMk8Bm
        5FRSRHH27UEDgv2AfNtJTF4jyNvakAXb1CdoPOH65Fnx6yTAv57p2hQOgefr6vRrms6LQELHhndiV
        T0AeEYzQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oDTKR-00CoXd-7k; Mon, 18 Jul 2022 16:10:39 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id D85E39802A7; Mon, 18 Jul 2022 18:10:36 +0200 (CEST)
Date:   Mon, 18 Jul 2022 18:10:36 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        x86@kernel.org, ardb@kernel.org, tglx@linutronix.de,
        gregkh@linuxfoundation.org, torvalds@linux-foundation.org,
        Guenter Roeck <linux@roeck-us.net>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>, stable@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>
Subject: Re: [PATCH] efi/x86: use naked RET on mixed mode call wrapper
Message-ID: <YtWF/GLXxBNQjkOX@worktop.programming.kicks-ass.net>
References: <20220715194550.793957-1-cascardo@canonical.com>
 <YtVG8VBmFikS6GMn@worktop.programming.kicks-ass.net>
 <YtVnNnyDjt2vrWiR@quatroqueijos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtVnNnyDjt2vrWiR@quatroqueijos>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 18, 2022 at 10:59:18AM -0300, Thadeu Lima de Souza Cascardo wrote:

> And I think you nailed what I had in mind for using IBPB when doing firmware
> calls, and perhaps this is wanted even when we ignore this naked RET here.
> 
> There is a typo on your patch below, but I will give it a try and see if it
> doesn't blow up on AMD systems without IBPB (by way of emulation).

Yeah, Boris pointed out the same. Typing is hard ;-)
