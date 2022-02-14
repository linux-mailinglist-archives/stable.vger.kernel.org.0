Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10DCD4B57AD
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 18:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356811AbiBNRB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 12:01:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356794AbiBNRBZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 12:01:25 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B347065164;
        Mon, 14 Feb 2022 09:01:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MrxZM+dtR1LjIHLm64CmzES4OEtfVkeNuYlvax0H88s=; b=1xI1/Fvb99aqHheC6mtY388ud6
        9MT/bHCftGydYIWxm+hS4zGwhvbFt8OzX+edrM5UnO4tP1NBqSh70Lw78bL6Q3BsXOm/Di6JZoJYH
        wtHggpB7JYRvrXSaY0/s1eEkO2PXvhxpwgVhrfp/eQEItM485WwqPYb5B+6tJYfNWM5IfOyU+3GNz
        wgU3yHvVJYtieNqr2ZSULdjEvye7TyhUfxnlCnsscD5y8hniE9PulQxdXM5zxaKuNaLViAmRHCutR
        73lx+6HTraO/VU29BXdY1lFIki5yroT8XZ/YKJV8c3pSdMpd1Wlg6zLRh5SejJ7jky/eNWrhj93gC
        ys6P1MSw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nJeis-00GF7n-M5; Mon, 14 Feb 2022 17:01:10 +0000
Date:   Mon, 14 Feb 2022 09:01:10 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, linux-api@vger.kernel.org, arnd@arndb.de,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com,
        dalias@libc.org, linux-ia64@vger.kernel.org,
        linux-sh@vger.kernel.org, peterz@infradead.org, jcmvbkbc@gmail.com,
        guoren@kernel.org, sparclinux@vger.kernel.org,
        linux-hexagon@vger.kernel.org, linux-riscv@lists.infradead.org,
        will@kernel.org, ardb@kernel.org, linux-s390@vger.kernel.org,
        bcain@codeaurora.org, deller@gmx.de, x86@kernel.org,
        linux@armlinux.org.uk, linux-csky@vger.kernel.org,
        mingo@redhat.com, geert@linux-m68k.org,
        linux-snps-arc@lists.infradead.org, linux-xtensa@linux-xtensa.org,
        hca@linux.ibm.com, linux-alpha@vger.kernel.org,
        linux-um@lists.infradead.org, linux-m68k@lists.linux-m68k.org,
        openrisc@lists.librecores.org, green.hu@gmail.com,
        shorne@gmail.com, linux-arm-kernel@lists.infradead.org,
        monstr@monstr.eu, tsbogend@alpha.franken.de,
        linux-parisc@vger.kernel.org, nickhu@andestech.com,
        linux-mips@vger.kernel.org, stable@vger.kernel.org,
        dinguyen@kernel.org, ebiederm@xmission.com, richard@nod.at,
        akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        davem@davemloft.net
Subject: Re: [PATCH 03/14] nds32: fix access_ok() checks in get/put_user
Message-ID: <YgqK1ihlJvRFHJ9h@infradead.org>
References: <20220214163452.1568807-1-arnd@kernel.org>
 <20220214163452.1568807-4-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214163452.1568807-4-arnd@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 14, 2022 at 05:34:41PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The get_user()/put_user() functions are meant to check for
> access_ok(), while the __get_user()/__put_user() functions
> don't.
> 
> This broke in 4.19 for nds32, when it gained an extraneous
> check in __get_user(), but lost the check it needs in
> __put_user().

Can we follow the lead of MIPS (which this was originally copied
from I think) and kill the pointless __get/put_user_check wrapper
that just obsfucate the code?
