Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39D3DEFFA8
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 15:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730922AbfKEO0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 09:26:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:53818 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727849AbfKEO0H (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Nov 2019 09:26:07 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 61FD1AFF3;
        Tue,  5 Nov 2019 14:26:04 +0000 (UTC)
Message-ID: <1572963963.2921.18.camel@suse.com>
Subject: Re: [PATCH 4.4 28/46] UAS: Revert commit 3ae62a42090f ("UAS: fix
 alignment of scatter/gather segments")
From:   Oliver Neukum <oneukum@suse.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Christoph Hellwig <hch@lst.de>
Date:   Tue, 05 Nov 2019 15:26:03 +0100
In-Reply-To: <20191104211901.335806642@linuxfoundation.org>
References: <20191104211830.912265604@linuxfoundation.org>
         <20191104211901.335806642@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Montag, den 04.11.2019, 22:44 +0100 schrieb Greg Kroah-Hartman:
> From: Alan Stern <stern@rowland.harvard.edu>
> 
> commit 1186f86a71130a7635a20843e355bb880c7349b2 upstream.
> 
> Commit 3ae62a42090f ("UAS: fix alignment of scatter/gather segments"),
> copying a similar commit for usb-storage, attempted to solve a problem
> involving scatter-gather I/O and USB/IP by setting the
> virt_boundary_mask for mass-storage devices.

We have that in 4.4.x

> However, it now turns out that the analogous change in usb-storage
> interacted badly with commit 09324d32d2a0 ("block: force an unlimited
> segment size on queues with a virt boundary"), which was added later.
> A typical error message is:

09324d32d2a0 I cannot find.

> 	ehci-pci 0000:00:13.2: swiotlb buffer is full (sz: 327680 bytes),
> 	total 32768 (slots), used 97 (slots)
> 
> There is no longer any reason to keep the virt_boundary_mask setting
> in the uas driver.  It was needed in the first place only for
> handling devices with a block size smaller than the maxpacket size and
> where the host controller was not capable of fully general
> scatter-gather operation (that is, able to merge two SG segments into
> a single USB packet).  But:
> 
> 	High-speed or slower connections never use a bulk maxpacket
> 	value larger than 512;
> 
> 	The SCSI layer does not handle block devices with a block size
> 	smaller than 512 bytes;
> 
> 	All the host controllers capable of SuperSpeed operation can
> 	handle fully general SG;
> 
> 	Since commit ea44d190764b ("usbip: Implement SG support to
> 	vhci-hcd and stub driver") was merged, the USB/IP driver can
> 	also handle SG.

Neither can I find ea44d190764b.

It seems to me that, while the patch is necessary in upstream, in 4.4.x
it would break usbip.

	Regards
		Oliver

