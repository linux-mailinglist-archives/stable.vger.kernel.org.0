Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE311EC6FD
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 03:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbgFCB6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 21:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbgFCB6M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 21:58:12 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A513C08C5C0;
        Tue,  2 Jun 2020 18:58:12 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.93 #3 (Red Hat Linux))
        id 1jgIfR-002Fxy-0t; Wed, 03 Jun 2020 01:58:09 +0000
Date:   Wed, 3 Jun 2020 02:58:08 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Namjae Jeon <namjae.jeon@samsung.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller@googlegroups.com, butterflyhuangxx@gmail.com,
        sj1557.seo@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH] exfat: fix memory leak in exfat_parse_param()
Message-ID: <20200603015808.GS23230@ZenIV.linux.org.uk>
References: <CGME20200603013447epcas1p45c6537dab8fee50f1f5b8fe7fd21da2b@epcas1p4.samsung.com>
 <20200603012957.9200-1-namjae.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603012957.9200-1-namjae.jeon@samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 03, 2020 at 10:29:57AM +0900, Namjae Jeon wrote:

> exfat_free() should call exfat_free_iocharset() after stealing
> param->string instead of kstrdup in exfat_parse_param().

ITYM
	extfat_free() should call exfat_free_iocharset(), to prevent
a leak in case we fail after parsing iocharset= but before calling
get_tree_bdev()

	Additionally, there's no point copying param->string in
exfat_parse_param() - just steal it, leaving NULL in param->string.
That's independent from the leak or fix thereof - it's simply
avoiding an extra copy.
