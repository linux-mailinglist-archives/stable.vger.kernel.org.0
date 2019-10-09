Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE10BD13BE
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 18:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730503AbfJIQLn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 12:11:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730708AbfJIQLk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 12:11:40 -0400
Received: from localhost (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 765EF218DE;
        Wed,  9 Oct 2019 16:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570637499;
        bh=YGif4PiaPGO3EZR76Hj4+v3j+m/F/2vFNS7I3C/lHAQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T8JgQra9OXJSAH5RFiM7/cWlSti4tZ6I4jw7P8rRretNyC9/4UycMVoPmmQJFci5n
         SkHKrbFpWnJJlM3JiP+Prlc9lskXFdG8O2v/2QKN/KKeKMrUhAWBXfL0x46n3h3KYH
         qpttjJ+BT88SUd5S1RNTAsR1Iw5dzmbpvr3LKVCU=
Date:   Wed, 9 Oct 2019 12:11:38 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     dave.jiang@intel.com, dan.j.williams@intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] libnvdimm: prevent nvdimm from requesting
 key when security" failed to apply to 5.3-stable tree
Message-ID: <20191009161138.GS1396@sasha-vm>
References: <157056215310918@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157056215310918@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 08, 2019 at 09:15:53PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.3-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 674f31a352da5e9f621f757b9a89262f486533a0 Mon Sep 17 00:00:00 2001
>From: Dave Jiang <dave.jiang@intel.com>
>Date: Tue, 24 Sep 2019 10:34:49 -0700
>Subject: [PATCH] libnvdimm: prevent nvdimm from requesting key when security
> is disabled
>
>Current implementation attempts to request keys from the keyring even when
>security is not enabled. Change behavior so when security is disabled it
>will skip key request.
>
>Error messages seen when no keys are installed and libnvdimm is loaded:
>
>    request-key[4598]: Cannot find command to construct key 661489677
>    request-key[4606]: Cannot find command to construct key 34713726
>
>Cc: stable@vger.kernel.org
>Fixes: 4c6926a23b76 ("acpi/nfit, libnvdimm: Add unlock of nvdimm support for Intel DIMMs")
>Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>Link: https://lore.kernel.org/r/156934642272.30222.5230162488753445916.stgit@djiang5-desk3.ch.intel.com
>Signed-off-by: Dan Williams <dan.j.williams@intel.com>

The issue was that the way we represent security flags changed due to
d78c620a2e824 ("libnvdimm/security: Introduce a 'frozen' attribute"). I
fixed up 674f31a352da5 to address that and queued it for 5.3.
