Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 409E52E9C27
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 18:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbhADRjG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 12:39:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51482 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726189AbhADRjG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 12:39:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609781860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YpjLLyzfgvor5Qp4xX0ApNSVlIIuMhLPOTOfFObDdfI=;
        b=Po8AsPZkkzbOkbkGNwWSdJXtnPKd1KvIjKgjplFUDM42cqAuXFiULCsbcNSsof4FzlykNi
        HYbT1cDJrokW2WYpmQ2rksX/+StAVSbeUQi8eA+0z4HOZBtgsujPfy/6vpRvHoxQl0Q4Hd
        QAJAGmyBIDazyuIyu/rVmIxrsYdz+CU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-NpA6vye-McOgdM06UMn4QQ-1; Mon, 04 Jan 2021 12:37:38 -0500
X-MC-Unique: NpA6vye-McOgdM06UMn4QQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 545DE107ACE3;
        Mon,  4 Jan 2021 17:37:37 +0000 (UTC)
Received: from suzdal.zaitcev.lan (ovpn-112-202.phx2.redhat.com [10.3.112.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C935B60BE5;
        Mon,  4 Jan 2021 17:37:36 +0000 (UTC)
Date:   Mon, 4 Jan 2021 11:37:36 -0600
From:   Pete Zaitcev <zaitcev@redhat.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        stable@vger.kernel.org, zaitcev@redhat.com
Subject: Re: [PATCH] USB: usblp: fix DMA to stack
Message-ID: <20210104113736.0af1ce0a@suzdal.zaitcev.lan>
In-Reply-To: <20210104145302.2087-1-johan@kernel.org>
References: <20210104145302.2087-1-johan@kernel.org>
Organization: Red Hat, Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon,  4 Jan 2021 15:53:02 +0100
Johan Hovold <johan@kernel.org> wrote:

> +++ b/drivers/usb/class/usblp.c
> -#define usblp_hp_channel_change_request(usblp, channel, buffer) \
> -	usblp_ctrl_msg(usblp, USBLP_REQ_HP_CHANNEL_CHANGE_REQUEST, USB_TYPE_VENDOR, USB_DIR_IN, USB_RECIP_INTERFACE, channel, buffer, 1)
> +static int usblp_hp_channel_change_request(struct usblp *usblp, int channel, u8 *new_channel)

Acked-By: Pete Zaitcev <zaitcev@redhat.com>

I would probably get rid of the buffer pointer and return
new_channel & 0xFF in case of success. That would kill
the newChannel too, and there's no need to debage u8 versus
unsigned char. But this is good enough. A function is better
than trying to cram the kfree() into the clause of the switch.

-- Pete

