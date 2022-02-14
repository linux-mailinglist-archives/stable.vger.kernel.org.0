Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1EF04B5798
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 17:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356783AbiBNQ7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 11:59:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233182AbiBNQ7U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 11:59:20 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D9665155;
        Mon, 14 Feb 2022 08:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=wOZdjvQKGo2j1KEbHamRz5nvfE
        5N4PSkoVJRW6b85x2udVgbP4nj0LjR0mptXcdR6Dl2/kevucNHdZKP+eczdjmlP1z3MwZ8V8UTNH8
        ZVh+IRtQLoUWBL/sUwTDW6NPocaC06jLxhF5rLfZ9wV8lGf6LC8Pw3PHj2ciuIshvT8D1htdXN0gu
        WGtLp38e6Ay0OYk4bAZhKzSgMaUKRfxf48LEOo7xoUHfsgFT50qfLq5mewlYarA7LCYzBR/7t7hIi
        rVhzxkKIih3DvtQfcPsFmsozbhFuJyeS1XTuYKGWC6P5G+i4WQv8FF5LABK6Yz9enYOIurecqRgkO
        e0Fnj0ng==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nJegk-00GDzZ-OZ; Mon, 14 Feb 2022 16:58:58 +0000
Date:   Mon, 14 Feb 2022 08:58:58 -0800
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
        dinguyen@kernel.org, David Laight <David.Laight@aculab.com>,
        ebiederm@xmission.com, richard@nod.at, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, davem@davemloft.net
Subject: Re: [PATCH 01/14] uaccess: fix integer overflow on access_ok()
Message-ID: <YgqKUscD4Xx62bVt@infradead.org>
References: <20220214163452.1568807-1-arnd@kernel.org>
 <20220214163452.1568807-2-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214163452.1568807-2-arnd@kernel.org>
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

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
