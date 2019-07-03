Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 679815DB47
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 04:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbfGCCCC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 22:02:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:51576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbfGCCCC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 22:02:02 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A66321721;
        Wed,  3 Jul 2019 02:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562119321;
        bh=Snc/t/lCtkBERwsYIRCa83hFKhk04PY6amxMNM7o1jw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0GoMmqJgtYnQap3xsd7R6I9G+9mr8xeeYGzCMG/thnbVnsTHoLKQ5dKzmfJVUFPIr
         bz7CSoLz9kByvAE9LEwBIAsgdHV2DAxdN5gGInlggcSfmBzZWFLOJovNMnI4aPkyVk
         ZAVK+7jz/WWa2Hbi+L5PwIe4sy8lbgD6GUL2QGbs=
Date:   Tue, 2 Jul 2019 22:02:00 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH 5.1 51/55] bpf, arm64: use more scalable stadd over ldxr
 / stxr loop in xadd
Message-ID: <20190703020200.GR11506@sasha-vm>
References: <20190702080124.103022729@linuxfoundation.org>
 <20190702080126.728030225@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190702080126.728030225@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 02, 2019 at 10:01:59AM +0200, Greg Kroah-Hartman wrote:
>From: Daniel Borkmann <daniel@iogearbox.net>
>
>commit 34b8ab091f9ef57a2bb3c8c8359a0a03a8abf2f9 upstream.
>
>Since ARMv8.1 supplement introduced LSE atomic instructions back in 2016,
>lets add support for STADD and use that in favor of LDXR / STXR loop for
>the XADD mapping if available. STADD is encoded as an alias for LDADD with
>XZR as the destination register, therefore add LDADD to the instruction
>encoder along with STADD as special case and use it in the JIT for CPUs
>that advertise LSE atomics in CPUID register. If immediate offset in the
>BPF XADD insn is 0, then use dst register directly instead of temporary
>one.
>
>Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>Acked-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
>Acked-by: Will Deacon <will.deacon@arm.com>
>Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This one has a fix upstream: c5e2edeb01ae9ffbdde95bdcdb6d3614ba1eb195
("arm64: insn: Fix ldadd instruction encoding").

--
Thanks,
Sasha
