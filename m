Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 360405E55D
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 15:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfGCNYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 09:24:41 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:45744 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726621AbfGCNYl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 09:24:41 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 71FA2404CF;
        Wed,  3 Jul 2019 13:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        user-agent:in-reply-to:content-disposition:content-type
        :content-type:mime-version:references:message-id:subject:subject
        :from:from:date:date:received:received:received; s=mta-01; t=
        1562160277; x=1563974678; bh=8aaSSBPPvnmQjKYICwro5iMnTGy3ei1sDS9
        Ie5CW9OU=; b=h7gQT6LzJL2An/tcbAHR7enXqg+udr+xtZl8pzZOgjCyWDpzb+/
        bZQrgTfkQxvLNdT5Vyl1iCIf4rDZHVGI8z/Eh/Om0dMcNvmVK9TgmiSmWMNdl1Dh
        13j0vNh8Q4xYo0NnzfwWrfw4HmOj9cn4d/TKmhWM6H/cxZkrwUVODnYk=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id VFxRkbpa4CvX; Wed,  3 Jul 2019 16:24:37 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id EDDD8404CB;
        Wed,  3 Jul 2019 16:24:36 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Wed, 3 Jul
 2019 16:24:36 +0300
Date:   Wed, 3 Jul 2019 16:24:36 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Michael Christie <mchristi@redhat.com>
CC:     <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <stable@vger.kernel.org>, Bart Van Assche <bvanassche@acm.org>
Subject: Re: [RESEND PATCH] scsi: target/iblock: Fix overrun in WRITE SAME
 emulation
Message-ID: <20190703132436.22k53mprnrn5fxcj@SPB-NB-133.local>
References: <20190702191636.26481-1-r.bolshakov@yadro.com>
 <a1c14025-cb00-7f64-a633-82019a3b6813@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a1c14025-cb00-7f64-a633-82019a3b6813@redhat.com>
User-Agent: NeoMutt/20180716
X-Originating-IP: [172.17.128.60]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 03, 2019 at 12:40:29PM +0900, Michael Christie wrote:
> On 07/03/2019 04:16 AM, Roman Bolshakov wrote:
> > WRITE SAME corrupts data on the block device behind iblock if the
> > command is emulated. The emulation code issues (M - 1) * N times more
> > bios than requested, where M is the number of 512 blocks per real block
> > size and N is the NUMBER OF LOGICAL BLOCKS specified in WRITE SAME
> > command. So, for a device with 4k blocks, 7 * N more LBAs gets written
> > after the requested range.
> > 
> > The issue happens because the number of 512 byte sectors to be written
> > is decreased one by one while the real bios are typically from 1 to 8
> > 512 byte sectors per bio.
> > 
> Roman,
> 
> The patch looks ok to me. Just one question. How did you hit this?
> 

Hi Michael,

The initiator was CentOS 7.x with distro kernel (3.10.0-x). There were
two cases:
 * Initiatalization [1] and online resize of ext4 filesystem [2]
   use WRITE SAME [3] for zeroing. TCM doesn't support RSOC, so
   the initiator defaults to using WRITE SAME (10). The filesystem
   showed errors after online resize;
 * a WRITE SAME command for the last LBA was stuck in multipath. TCM
   always returned LOGICAL UNIT NOT SUPPORTED for the command. The
   resason of the response is because some bios were sent beyond the
   sector limit. WRITE SAME with NUMBER OF LOGICAL BLOCKS == 1 was
   failing for the last 7 LBAs.

> Did you by any chance export this disk to a ESX initiator and was it
> doing WRITE SAME to zero out data. But, did the device being used by
> iblock not support the zero out command (was
> /sys/block/XYZ/queue/write_zeroes_max_bytes == 0)?
> 

It did not support zero out and write same, both
write_zeroes_max_bytes/write_same_max_bytes == 0

> Or, did you just send a WRITE SAME command manually using some tools
> like sg utils and it had a non zero'd buffer to write out?
> 

Yes, I triaged the issues above with sg_write_same/sg_dd and non-zero
buffer.

1. https://patchwork.ozlabs.org/patch/66590/
2. https://lists.openwall.net/linux-ext4/2012/01/04/14
3. https://www.spinics.net/lists/linux-scsi/msg57783.html

Best regards,
Roman
