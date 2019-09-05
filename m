Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF06AAB60
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 20:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388258AbfIESrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 14:47:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388235AbfIESrj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Sep 2019 14:47:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20B3C20825;
        Thu,  5 Sep 2019 18:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567709259;
        bh=eswc6e7PS11qFRA+pb6RWFwrYLnlAocTlT0WwvnKDM8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fxm3fKmai5Bwytz32dHXB5bIEOG2oI7Va/HGzhqfV6l83B0/v5L6hnIiKbWFNTcLh
         sGZK5p6+DxT0g9NnZE9IvZVzbzop1yy4fVgjkMqSH0EIQiXQW4V57XRCEADqatHJ7r
         tWvQbQgyKQTDewG7961CuN5ov1J6lfntV/BUoVyo=
Date:   Thu, 5 Sep 2019 20:47:35 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+c6167ec3de7def23d1e8@syzkaller.appspotmail.com,
        Arvid Brodin <arvid.brodin@alten.se>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.2 143/143] hsr: implement dellink to clean up resources
Message-ID: <20190905184735.GA24300@kroah.com>
References: <20190904175314.206239922@linuxfoundation.org>
 <20190904175320.090038891@linuxfoundation.org>
 <20190904212040.GA1616@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904212040.GA1616@sasha-vm>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 04, 2019 at 05:20:40PM -0400, Sasha Levin wrote:
> On Wed, Sep 04, 2019 at 07:54:46PM +0200, Greg Kroah-Hartman wrote:
> > From: Cong Wang <xiyou.wangcong@gmail.com>
> > 
> > commit b9a1e627405d68d475a3c1f35e685ccfb5bbe668 upstream.
> > 
> > hsr_link_ops implements ->newlink() but not ->dellink(),
> > which leads that resources not released after removing the device,
> > particularly the entries in self_node_db and node_db.
> > 
> > So add ->dellink() implementation to replace the priv_destructor.
> > This also makes the code slightly easier to understand.
> > 
> > Reported-by: syzbot+c6167ec3de7def23d1e8@syzkaller.appspotmail.com
> > Cc: Arvid Brodin <arvid.brodin@alten.se>
> > Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> If the airport gods cooperate, I'm going to queue:
> 
> edf070a0fb45a ("hsr: fix a NULL pointer deref in hsr_dev_xmit()")
> 311633b604063 ("hsr: switch ->dellink() to ->ndo_uninit()")
> 
> as fixes for this commit.

Ugh, sorry about that, I need to fix up my scripts :(

greg k-h
