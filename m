Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D795229ED4
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 21:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727344AbfEXTJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 15:09:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727115AbfEXTJo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 May 2019 15:09:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 762352175B;
        Fri, 24 May 2019 19:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558724984;
        bh=rViWCO4NqI43asf5Tq/IFk6AzanhJwwCd6fbS89zBxY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lRIfeK4gJWRKNhSlttJahVSg02nFW7UDWLQwaKX3Ib5IW+CbDA1crArpjEZ8VfL0P
         TvaTLBgMZL5ukfM4AdeRxBOGTm925ZkRr0sX5Z3m22b2JvLAxKMS4p1Y0IYQsPX9vL
         WfVoyPt3T5biZTI704QtXftl+MKVNU/7HLHggCwk=
Date:   Fri, 24 May 2019 21:09:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        Allison Randal <allison@lohutok.net>,
        Steve Winslow <swinslow@gmail.com>,
        Wen Yang <wen.yang99@zte.com.cn>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: Re: [PATCH v2] media: smsusb: better handle optional alignment
Message-ID: <20190524190941.GA18849@kroah.com>
References: <c53ea00f339529f69b89deac620e4ab540717eb9.1558709939.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c53ea00f339529f69b89deac620e4ab540717eb9.1558709939.git.mchehab+samsung@kernel.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 24, 2019 at 10:59:43AM -0400, Mauro Carvalho Chehab wrote:
> Most Siano devices require an alignment for the response.
> 
> Changeset f3be52b0056a ("media: usb: siano: Fix general protection fault in smsusb")
> changed the logic with gets such aligment, but it now produces a
> sparce warning:
> 
> drivers/media/usb/siano/smsusb.c: In function 'smsusb_init_device':
> drivers/media/usb/siano/smsusb.c:447:37: warning: 'in_maxp' may be used uninitialized in this function [-Wmaybe-uninitialized]
>   447 |   dev->response_alignment = in_maxp - sizeof(struct sms_msg_hdr);
>       |                             ~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> The sparse message itself is bogus, but a broken (or fake) USB
> eeprom could produce a negative value for response_alignment.
> 
> So, change the code in order to check if the result is not
> negative.
> 
> Fixes: f3be52b0056a ("media: usb: siano: Fix general protection fault in smsusb")
> CC: <stable@vger.kernel.org>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
> 
> Greg,
> 
> As the Alan patches went via your tree, please apply this one too.

Thanks, now done, and I fixed up the Fixes: sha1 tag to match my tree.

greg k-h
