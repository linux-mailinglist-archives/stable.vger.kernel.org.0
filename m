Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCAD380E16
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 18:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhENQWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 12:22:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231132AbhENQWx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 May 2021 12:22:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB1AB61073;
        Fri, 14 May 2021 16:21:40 +0000 (UTC)
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>
Cc:     Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        stable@vger.kernel.org, Steven Price <steven.price@arm.com>
Subject: Re: [PATCH] arm64: Fix race condition on PG_dcache_clean in __sync_icache_dcache()
Date:   Fri, 14 May 2021 17:21:39 +0100
Message-Id: <162100929465.16775.12776421350140482126.b4-ty@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210514095001.13236-1-catalin.marinas@arm.com>
References: <20210514095001.13236-1-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 14 May 2021 10:50:01 +0100, Catalin Marinas wrote:
> To ensure that instructions are observable in a new mapping, the arm64
> set_pte_at() implementation cleans the D-cache and invalidates the
> I-cache to the PoU. As an optimisation, this is only done on executable
> mappings and the PG_dcache_clean page flag is set to avoid future cache
> maintenance on the same page.
> 
> When two different processes map the same page (e.g. private executable
> file or shared mapping) there's a potential race on checking and setting
> PG_dcache_clean via set_pte_at() -> __sync_icache_dcache(). While on the
> fault paths the page is locked (PG_locked), mprotect() does not take the
> page lock. The result is that one process may see the PG_dcache_clean
> flag set but the I/D cache maintenance not yet performed.
> 
> [...]

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64: Fix race condition on PG_dcache_clean in __sync_icache_dcache()
      https://git.kernel.org/arm64/c/588a513d3425

-- 
Catalin

