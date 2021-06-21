Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632EA3AEAA0
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 15:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhFUOAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 10:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbhFUOAV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 10:00:21 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94152C061574
        for <stable@vger.kernel.org>; Mon, 21 Jun 2021 06:58:07 -0700 (PDT)
Received: from maud (unknown [IPv6:2600:8800:8c04:8c00::912b])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: alyssa)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id E9D631F422F0;
        Mon, 21 Jun 2021 14:58:02 +0100 (BST)
Date:   Mon, 21 Jun 2021 09:57:55 -0400
From:   Alyssa Rosenzweig <alyssa@collabora.com>
To:     Boris Brezillon <boris.brezillon@collabora.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        dri-devel@lists.freedesktop.org, Icecream95 <ixn@keemail.me>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 01/12] drm/panfrost: Make sure MMU context lifetime is
 not bound to panfrost_priv
Message-ID: <YNCa46vEbjzWvrLn@maud>
References: <20210621133907.1683899-1-boris.brezillon@collabora.com>
 <20210621133907.1683899-2-boris.brezillon@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621133907.1683899-2-boris.brezillon@collabora.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Jobs can be in-flight when the file descriptor is closed (either because
> the process did not terminate properly, or because it didn't wait for
> all GPU jobs to be finished), and apparently panfrost_job_close() does
> not cancel already running jobs. Let's refcount the MMU context object
> so it's lifetime is no longer bound to the FD lifetime and running jobs
> can finish properly without generating spurious page faults.

Remind me - why can't we hard stop in-flight jobs when the fd is closed?
I've seen cases where kill -9'ing a badly behaved process doesn't end
the fault storm, or unfreeze the desktop.
