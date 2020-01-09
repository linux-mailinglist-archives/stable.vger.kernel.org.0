Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03FF7135B76
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 15:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731726AbgAIOfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 09:35:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:38806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729577AbgAIOfj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Jan 2020 09:35:39 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0715B2077B;
        Thu,  9 Jan 2020 14:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578580539;
        bh=6WcORVtf3DjfJCucb8ciuJeOMemSw+59Xl2wf5Zg4As=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JLcoFRE0CEI7rPiUjb8T/kz3hk2H769jyw7uuBhU49RmZ4zEs9p46DqAOS5b2bRy9
         6VyNrlThT3o75JaweEKKKaEBq8ZmQE4NHf9JZluGVF82sah/LMOlJ9OcGJhyd1Bfzg
         2MMAGgxQME80cfdAM2ugWu8VvdVlTa1nwwTEC49M=
Date:   Thu, 9 Jan 2020 09:35:37 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mathieu.poirier@linaro.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH 1/2] coresight: etb10: Do not call
 smp_processor_id from preemptible
Message-ID: <20200109143537.GE1706@sasha-vm>
References: <20200108110541.318672-1-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200108110541.318672-1-suzuki.poulose@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 08, 2020 at 11:05:40AM +0000, Suzuki K Poulose wrote:
>[ Upstream commit 730766bae3280a25d40ea76a53dc6342e84e6513 ]
>
>During a perf session we try to allocate buffers on the "node" associated
>with the CPU the event is bound to. If it is not bound to a CPU, we
>use the current CPU node, using smp_processor_id(). However this is unsafe
>in a pre-emptible context and could generate the splats as below :
>
> BUG: using smp_processor_id() in preemptible [00000000] code: perf/2544
>
>Use NUMA_NO_NODE hint instead of using the current node for events
>not bound to CPUs.
>
>Fixes: 2997aa4063d97fdb39 ("coresight: etb10: implementing AUX API")
>Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
>Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>Cc: stable <stable@vger.kernel.org> # v4.9 to v4.19
>Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
>Link: https://lore.kernel.org/r/20190620221237.3536-5-mathieu.poirier@linaro.org

I've queued this for 4.9-4.19. There was a simple conflict on 4.9 which
also had to be resolved.

-- 
Thanks,
Sasha
