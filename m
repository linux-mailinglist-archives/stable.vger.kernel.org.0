Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A73425691
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 19:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbfEURW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 13:22:59 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:46932 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728114AbfEURW7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 May 2019 13:22:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=F6hzvh3Jla0WhoTxfizl6fXxrFIMr5UOMU03ImxH5Ac=; b=b+/W6d2WiUF/OIvuwtkfb/SkH
        /3+H3kA7ADfToOu3edm4BJ3fw83zXGvUfTGn1nWi+7xh+UsRyQzwtjc5D7TE5KH0Yxdt2+Ntb1JuT
        k+UkYrfqVygj7Ya7vRRjZeMSv7/0B8vELoNfEcC5S6znYc0nJZ45UQ6g/RrdMF3atTmuXQGLIkUeL
        FSIJnnHuCkxK5wpUfYxJ4YtgoLzHO7WvKGn80nF/J8dK81cS52b2JeWuhIINVflNpYjn/gopPVt7r
        8wdidUGKN9XC0VtidvYMf7NIFF+tcNRHEnIFVJhWN8Eu0WFbjrUqmsi1Oyaz1Ie9gtNMgjKTgf+JY
        xAmvcaRsw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hT8Ta-0002Ug-G4; Tue, 21 May 2019 17:22:58 +0000
Date:   Tue, 21 May 2019 10:22:58 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Guilherme Piccoli <gpiccoli@canonical.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com,
        axboe@kernel.dk, Gavin Guo <gavin.guo@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        "Guilherme G. Piccoli" <kernel@gpiccoli.net>,
        Ming Lei <ming.lei@redhat.com>,
        Song Liu <liu.song.a23@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        stable@vger.kernel.org
Subject: Re: [PATCH V2 2/2] md/raid0: Do not bypass blocking queue entered
 for raid0 bios
Message-ID: <20190521172258.GA32702@infradead.org>
References: <20190520220911.25192-1-gpiccoli@canonical.com>
 <20190520220911.25192-2-gpiccoli@canonical.com>
 <20190521125634.GB16799@infradead.org>
 <CAHD1Q_z23AO+NRid1xYTeke_5GAe6hPianEZKBf5P30FrfZGFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHD1Q_z23AO+NRid1xYTeke_5GAe6hPianEZKBf5P30FrfZGFg@mail.gmail.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 21, 2019 at 11:10:05AM -0300, Guilherme Piccoli wrote:
> Hi Christoph, thanks for looking into this.
> You're right, this series fixes both issues. The problem I see though
> is that it relies
> on legacy IO path removal - for v5.0 and beyond, all fine. But
> backporting that to
> v4.17-v4.20 stable series will be quite painful.
> 
> My fixes are mostly "oneliners". If we could get both approaches upstream,
> that'd be perfect!

But they basically just fix code that otherwise gets removed.  And the way
this patches uses the ENTERED flag from the md code looks slightly
sketchy to me.  Maybe we want them as stable only patches.
