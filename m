Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D2724824A
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 11:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgHRJw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 05:52:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726484AbgHRJwz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 05:52:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5ED420738;
        Tue, 18 Aug 2020 09:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597744375;
        bh=xdS+b75ghYmvRyp5w9RPdxKoug0EJ/G+RiOriB8x2Hk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G2nzMHixlR6257icH9egqpc70o0BhDsW4O8+t+2Ivyzzp7ScpRlqfPKrVthkuEJst
         1tngXqow2SmSDX0R9ZAAOq47rOq0J8lZ5kghwqVli8sXOW8WcX7Ee/KzcO9XXmaoY3
         48Q+5RkPW2HFSN5b0NaKLDTTLHUjoTIVMufaB0oU=
Date:   Tue, 18 Aug 2020 11:53:18 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+96414aa0033c363d8458@syzkaller.appspotmail.com,
        Lihong Kou <koulihong@huawei.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 027/168] Bluetooth: add a mutex lock to avoid UAF in
 do_enale_set
Message-ID: <20200818095318.GA57268@kroah.com>
References: <20200817143733.692105228@linuxfoundation.org>
 <20200817143735.099152549@linuxfoundation.org>
 <20200818094024.GB10974@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818094024.GB10974@amd>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 18, 2020 at 11:40:25AM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Lihong Kou <koulihong@huawei.com>
> > 
> > [ Upstream commit f9c70bdc279b191da8d60777c627702c06e4a37d ]
> > 
> > In the case we set or free the global value listen_chan in
> > different threads, we can encounter the UAF problems because
> > the method is not protected by any lock, add one to avoid
> > this bug.
> 
> For this to be safe, bt_6lowpan_exit() needs same handling, no?
> 
> Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
> 
> diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
> index 9a75f9b00b51..2402ef5ac072 100644
> --- a/net/bluetooth/6lowpan.c
> +++ b/net/bluetooth/6lowpan.c
> @@ -1304,10 +1304,12 @@ static void __exit bt_6lowpan_exit(void)
>  	debugfs_remove(lowpan_enable_debugfs);
>  	debugfs_remove(lowpan_control_debugfs);
>  
> +	mutex_lock(&set_lock);
>  	if (listen_chan) {
>  		l2cap_chan_close(listen_chan, 0);
>  		l2cap_chan_put(listen_chan);
>  	}
> +	mutex_unlock(&set_lock);
>  
>  	disconnect_devices();
>  
> 
> 

Why you are sending this in this format seems very odd to me, you know
better...
