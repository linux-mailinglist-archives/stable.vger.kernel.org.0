Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F05F2502590
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 08:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350436AbiDOGar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 02:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236018AbiDOGaq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 02:30:46 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF66A1459;
        Thu, 14 Apr 2022 23:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tTulKxlD0lA9qywlBH9VasRCj28V8Ec2TAqTh6v1Jso=; b=EXrPd0v9wBTLQFs0a+ktyKD7k8
        IPqgWPomQLt/XLkXkWJXoAyHSpc/ndI4Jf5USuKEDUFEj5wB7zfGXwE3EXFoUdK0OjgDhVNfEVdSu
        b9gd7Mw9paUmM4+JP3ddNcFNRDRu4UtXobD9C1PCmLCqYY++BagpKhr/5B+Dl6WhR9xrgcnkWyVuV
        czmfE06hvXacEaUkLN6ftMWzK7Kd0NgFJzshLx0HD90rsQX8KmJ8pn/g1Z4KLC5x5e871yCkROL81
        LAge7keZWS7CYRDPkCy+xxEm0HzbZiTKkLniJBAXLHx+S389/6CeTx5b5U9HSGlmmKz53CK1pyhCo
        McahsKrQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nfFRJ-008zVp-MV; Fri, 15 Apr 2022 06:28:17 +0000
Date:   Thu, 14 Apr 2022 23:28:17 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] btrfs: avoid double clean up when
 submit_one_bio() failed
Message-ID: <YlkQgTCv+Iw2QzPz@infradead.org>
References: <cover.1649766550.git.wqu@suse.com>
 <0b13dccbc4d6e066530587d6c00c54b10c3d00d7.1649766550.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b13dccbc4d6e066530587d6c00c54b10c3d00d7.1649766550.git.wqu@suse.com>
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

Btw, btrfs_submit_compressed_write also seems to do some double cleanups,
even if the pattern is slightly different as the bio is allocated inside
btrfs_submit_compressed_write itself.  Can someone who is more familiar
with that code look into that?
