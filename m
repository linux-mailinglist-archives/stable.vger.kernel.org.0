Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 343D619D042
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 08:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388057AbgDCGfc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 02:35:32 -0400
Received: from verein.lst.de ([213.95.11.211]:51254 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730759AbgDCGfb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Apr 2020 02:35:31 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id AB83F68B05; Fri,  3 Apr 2020 08:35:28 +0200 (CEST)
Date:   Fri, 3 Apr 2020 08:35:28 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-nvme@lists.infradead.org, stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH] nvme-fc: revert controller references on lldd module
Message-ID: <20200403063528.GA23224@lst.de>
References: <20200402190312.88868-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402190312.88868-1-jsmart2021@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 02, 2020 at 12:03:12PM -0700, James Smart wrote:
> This patch partially reverts the commit for
>   nvme_fc: add module to ops template to allow module references
> 
> The original patch:
>   Added an ops parameter of "module" to be set by the lldd, and the
>     lldds were updated to provide their value.
>   Used the parameter to take module references when a controller was
>     created or terminated.
> 
> The original patch was to resolve the lldd being able to be unloaded
> while being used to talk to the boot device of the system. However, the
> end result of the original patch is that any driver unload while a nvme
> controller is live via the lldd is not being prohibited. Given the module
> reference, the module teardown routine can't be called, thus there's no
> way, other than manual actions to terminate the controllers.
> 
> This patch reverts the portion of the patch that takes module references
> on controller creation. It leaves the module parameter so that it could
> be used in the future.

Please remove it entirely - we don't want to keep dead code around.
