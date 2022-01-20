Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD04494A50
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 10:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358549AbiATJGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 04:06:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbiATJGE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 04:06:04 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3054C061574;
        Thu, 20 Jan 2022 01:06:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MRs3424m0fnPiwGx/a/rjtssSkFIj5i4duSOOwxobJA=; b=0ooSrFcGduLj6YqSuV5iVhl7Zy
        CANI9PkHey/6OtcVzzSe/UtjYh1rSToYwIyvIOrkjpKqhUD50AZGk4DVvTFCZFqT7e9B04rSiBoMW
        zLrM8UEg32wB+SM8kpe6jv0t4B3xgQX+NGS3bMvXIBvQGqKFx8EVK/kuf9UKVd+yOKegx7QZixZbZ
        +dgET631625fJ30+u73qDn3byYB5JMGLcj/e8+lzOadSPSF+ZfpVeOQO6F3ySMmUn7vlYD+0XWvkK
        j4NgkqMMr/F2mSBE434bkohdn9QQdSo2IAGBa74egNl9jbytru8XrrdpjGvWp8Jvqv4tVRaTaa6AI
        E6md+0rA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nATON-00A3fw-K2; Thu, 20 Jan 2022 09:06:03 +0000
Date:   Thu, 20 Jan 2022 01:06:03 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-fsdevel@vger.kernel.org,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] udf: Restore i_lenAlloc when inode expansion fails
Message-ID: <Yekl+0/fagqyUNin@infradead.org>
References: <20220118095449.2937-1-jack@suse.cz>
 <20220118095753.627-2-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118095753.627-2-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18, 2022 at 10:57:48AM +0100, Jan Kara wrote:
> When we fail to expand inode from inline format to a normal format, we
> restore inode to contain the original inline formatting but we forgot to
> set i_lenAlloc back. The mismatch between i_lenAlloc and i_size was then
> causing further problems such as warnings and lost data down the line.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Btw, how did the reported even hit that failure in a way where the
file system continues working?  If we fail to write back data we'd
probably better stop modifying anything and bail out..
