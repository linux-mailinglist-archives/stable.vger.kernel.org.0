Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC71A29D3ED
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 22:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbgJ1VsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 17:48:02 -0400
Received: from gentwo.org ([3.19.106.255]:34068 "EHLO gentwo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727781AbgJ1Vrw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Oct 2020 17:47:52 -0400
Received: by gentwo.org (Postfix, from userid 1002)
        id E4C6A3FCCF; Wed, 28 Oct 2020 11:11:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
        by gentwo.org (Postfix) with ESMTP id E14743F7B6;
        Wed, 28 Oct 2020 11:11:20 +0000 (UTC)
Date:   Wed, 28 Oct 2020 11:11:20 +0000 (UTC)
From:   Christopher Lameter <cl@linux.com>
X-X-Sender: cl@www.lameter.com
To:     Laurent Dufour <ldufour@linux.ibm.com>
cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        nathanl@linux.ibm.com, cheloha@linux.ibm.com, mhocko@suse.com,
        Vlastimil Babka <vbabka@suse.cz>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/slub: fix panic in slab_alloc_node()
In-Reply-To: <20201027190406.33283-1-ldufour@linux.ibm.com>
Message-ID: <alpine.DEB.2.22.394.2010281109580.1521@www.lameter.com>
References: <7ef64e75-2150-01a9-074d-a754348683b3@suse.cz> <20201027190406.33283-1-ldufour@linux.ibm.com>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 27 Oct 2020, Laurent Dufour wrote:

> The issue is that object is not NULL while page is NULL which is odd but
> may happen if the cache flush happened after loading object but before
> loading page. Thus checking for the page pointer is required too.


Ok then lets revert commit  6159d0f5c03e? The situation may occur
elsewhere too.
