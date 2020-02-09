Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1BB0156BFB
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 19:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbgBISKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 13:10:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:51704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727388AbgBISKg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 13:10:36 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D1DB20715;
        Sun,  9 Feb 2020 18:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581271835;
        bh=KBfdYkY2Hv2nOagMLSoOYDky5QFExKfE/afdxzTsCls=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wrv5FXali5ocCiuv7vjoQxScivwv/ZU/lvg5G4cVT0Q6HWSKS+yk8TVAxWRIADOIM
         WTSA2KTdFh+E4et86HsB2bcbgUfJcLmTa1rgVRz/3MmpWzi97jXJpQx2VZdM2wsOHW
         KN1nq9h/OnZxBx9LHzmNn1ca3qTinqhumnsBKkec=
Date:   Sun, 9 Feb 2020 13:10:34 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     Wayne.Lin@amd.com, lyude@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm/dp_mst: Remove VCPI while disabling
 topology mgr" failed to apply to 5.5-stable tree
Message-ID: <20200209181034.GK3584@sasha-vm>
References: <158124846315195@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158124846315195@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 12:41:03PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.5-stable tree.
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
>From 64e62bdf04ab8529f45ed0a85122c703035dec3a Mon Sep 17 00:00:00 2001
>From: Wayne Lin <Wayne.Lin@amd.com>
>Date: Thu, 5 Dec 2019 17:00:43 +0800
>Subject: [PATCH] drm/dp_mst: Remove VCPI while disabling topology mgr
>
>[Why]
>
>This patch is trying to address the issue observed when hotplug DP
>daisy chain monitors.
>
>e.g.
>src-mstb-mstb-sst -> src (unplug) mstb-mstb-sst -> src-mstb-mstb-sst
>(plug in again)
>
>Once unplug a DP MST capable device, driver will call
>drm_dp_mst_topology_mgr_set_mst() to disable MST. In this function,
>it cleans data of topology manager while disabling mst_state. However,
>it doesn't clean up the proposed_vcpis of topology manager.
>If proposed_vcpi is not reset, once plug in MST daisy chain monitors
>later, code will fail at checking port validation while trying to
>allocate payloads.
>
>When MST capable device is plugged in again and try to allocate
>payloads by calling drm_dp_update_payload_part1(), this
>function will iterate over all proposed virtual channels to see if
>any proposed VCPI's num_slots is greater than 0. If any proposed
>VCPI's num_slots is greater than 0 and the port which the
>specific virtual channel directed to is not in the topology, code then
>fails at the port validation. Since there are stale VCPI allocations
>from the previous topology enablement in proposed_vcpi[], code will fail
>at port validation and reurn EINVAL.
>
>[How]
>
>Clean up the data of stale proposed_vcpi[] and reset mgr->proposed_vcpis
>to NULL while disabling mst in drm_dp_mst_topology_mgr_set_mst().
>
>Changes since v1:
>*Add on more details in commit message to describe the issue which the
>patch is trying to fix
>
>Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
>[added cc to stable]
>Signed-off-by: Lyude Paul <lyude@redhat.com>
>Link: https://patchwork.freedesktop.org/patch/msgid/20191205090043.7580-1-Wayne.Lin@amd.com
>Cc: <stable@vger.kernel.org> # v3.17+

Context conflict because we don't have f79489074c59 ("drm/dp_mst: Clear
all payload id tables downstream when initializing") in older kernels.

Cleaned up and queued for 5.5-4.4.

-- 
Thanks,
Sasha
