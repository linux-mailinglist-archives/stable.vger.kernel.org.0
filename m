Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1419B36CADD
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 20:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236740AbhD0SG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 14:06:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:50588 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230219AbhD0SG1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Apr 2021 14:06:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EAE5BADB3;
        Tue, 27 Apr 2021 18:05:42 +0000 (UTC)
To:     Christoph Hellwig <hch@lst.de>
Cc:     mwilck@suse.com, Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chao Leng <lengchao@huawei.com>,
        Daniel Wagner <dwagner@suse.de>,
        linux-nvme@lists.infradead.org, stable@vger.kernel.org
References: <20210427085246.13728-1-mwilck@suse.com>
 <0ff2dbc0-0182-f54d-b750-084feac53601@suse.de>
 <20210427162521.GA26528@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Subject: Re: [PATCH v3] nvme: rdma/tcp: fix list corruption with anatt timer
Message-ID: <f82b7f7c-ef12-27bb-1349-d23ea22e50a9@suse.de>
Date:   Tue, 27 Apr 2021 20:05:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210427162521.GA26528@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/27/21 6:25 PM, Christoph Hellwig wrote:
> On Tue, Apr 27, 2021 at 11:33:04AM +0200, Hannes Reinecke wrote:
>> As indicated in my previous mail, please change the description. We have
>> since established a actual reason (duplicate calls to add_timer()), so
>> please list it here.
> 
> So what happens if the offending add_timer is changed to mod_timer?
> 
I guess that should be fine, as the boilerplate said it can act
as a safe version of add_timer.

But that would just solve the crash upon add_timer(). We still have the
problem that the anatt timer might trigger just _after_ eg
nvme_tcp_teardown_admin_queue(), causing it to hit an invalid admin queue.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
