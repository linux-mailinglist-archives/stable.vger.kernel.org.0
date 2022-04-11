Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A703C4FB481
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 09:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234453AbiDKHWB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 03:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245268AbiDKHWA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 03:22:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D357B22519;
        Mon, 11 Apr 2022 00:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AR8QC61yGQHhMbaA1VOmFDdMiWypclNTg/sdPKKzHrg=; b=QhuTMRZ62mi0LUOB7325zEvr1c
        fJCpbf7TIXY4Lqlj6F0Vk4jfXzHB6vQ7DYmpA9xa2If0dCmUZKgqDX5j7sjiAYElokO6zFrsOB12y
        cTMwhE3BOty8BjxYN0UoQ5OggfptIOvGY9Zteofpu0mXSuGRVOL5J30LGIrfI8sjfMc9ZQT2kzxYL
        63O8dBk/GP0zf5jOFGmASNHSjHhYXrw7Orvrns60XaEAtk4Y45yevueYhyQix7lR4CcgoUC9b7uzL
        NGyMOpQ5yvNq0mDZQ43kYt20+uxGRFnLlzPLh/o9aS3rkFpPjWNUjxvGlPIGSqzSPxZaK0cIOaU4Y
        9y4zK8vQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ndoKu-0079wR-Jz; Mon, 11 Apr 2022 07:19:44 +0000
Date:   Mon, 11 Apr 2022 00:19:44 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/4] btrfs: avoid double clean up when submit_one_bio()
 failed
Message-ID: <YlPWkL4uYBah7Elo@infradead.org>
References: <cover.1649657016.git.wqu@suse.com>
 <6b8983dd0a3a28155fa7d786bae0a8bf932cdbab.1649657016.git.wqu@suse.com>
 <YlPVQtbeJ9qQVDzg@infradead.org>
 <63cca59f-5962-339c-db9d-c93255962a65@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63cca59f-5962-339c-db9d-c93255962a65@gmx.com>
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

On Mon, Apr 11, 2022 at 03:15:23PM +0800, Qu Wenruo wrote:
> This patch itself is for backport, thus I didn't change the return type
> to make backport easier.

Umm, if you don't remove all that buggy error handling code in a
backport you'll have to fix it.  So do the right thing here and just
get rid of it ASAP including for the backport.
