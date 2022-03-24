Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D114B4E6A43
	for <lists+stable@lfdr.de>; Thu, 24 Mar 2022 22:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348310AbiCXVep (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 17:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354166AbiCXVem (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 17:34:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367A622283;
        Thu, 24 Mar 2022 14:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZNh9mUSD119F1hcQ1c9te8DtDTYrhgO4FD2R2alLdsw=; b=cR6/luJzlOlQmjZ0FsCcz9k0Wo
        b62ukwJP90JJkQSM9G8IurwPFn8pc24yG3sZtdSzo08Eg8W713GSvolU4181PYKtopFDvIyoYBf09
        sVTlKWo2SfNYh1V3n6XDC1ha1NouZGO2Fg3Hfu9Pzd+7Ycm/bMk7tX0ffpkptJNU4aDGmbVEWYvBs
        E0vdswIIND5t50Q5THqAYsLbEqwhnQUFVBvx4aGzlAl2wMiLRHyj6xa+DefOAV8b3HEsRV4mBcqhp
        KbU38u45kiCcJH5yoXtL3BPn4oB54svqYzJEHGKRqaTTn2lNEcpSayYt2W5WpwbaBIbaHxDENNwbH
        V2ngWzXg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nXV4i-00DlvS-Cw; Thu, 24 Mar 2022 21:32:56 +0000
Date:   Thu, 24 Mar 2022 21:32:56 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Axel Rasmussen <axelrasmussen@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/secretmem: fix panic when growing a memfd_secret
Message-ID: <YjzjiDFBgigPqEO9@casper.infradead.org>
References: <20220324210909.1843814-1-axelrasmussen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220324210909.1843814-1-axelrasmussen@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 24, 2022 at 02:09:09PM -0700, Axel Rasmussen wrote:
> This patch avoids the panic by implementing a custom setattr for
> memfd_secret, which detects resizes specifically (setting the size for
> the first time works just fine, since there are no existing pages to try
> to zero), and rejects them as not supported (ENOTSUP).

Isn't ENOTTY the normal return value for this?  Or even ENOSYS?
