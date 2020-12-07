Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60572D1D9C
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 23:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbgLGWn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 17:43:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50184 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbgLGWn3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 17:43:29 -0500
Received: from 2.general.kamal.us.vpn ([10.172.68.52] helo=ascalon)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kamal@canonical.com>)
        id 1kmPDS-0003mF-DZ; Mon, 07 Dec 2020 22:42:46 +0000
Received: from kamal by ascalon with local (Exim 4.90_1)
        (envelope-from <kamal@ascalon>)
        id 1kmPDN-0002LH-G4; Mon, 07 Dec 2020 14:42:41 -0800
Date:   Mon, 7 Dec 2020 14:42:40 -0800
From:   Kamal Mostafa <kamal@canonical.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Verbeiren <david.verbeiren@tessares.net>,
        stable@vger.kernel.org
Subject: Re: [5.4.y] selftests/bpf build broken by "bpf: Zero-fill..."
Message-ID: <20201207224238.GA28646@ascalon>
References: <20201204182846.27110-1-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201204182846.27110-1-kamal@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 04, 2020 at 10:28:46AM -0800, Kamal Mostafa wrote:
> Hi Sasha-
> 
> This v5.4.78 commit breaks the tools/testing/selftests/bpf build:
> 
> [linux-5.4.y] c602ad2b52dc bpf: Zero-fill re-used per-cpu map element
> 
> Like this:
> 
> 	prog_tests/map_init.c:5:10: fatal error: test_map_init.skel.h: No such file or directory
> 	    5 | #include "test_map_init.skel.h"
> 
> Because tools/testing/selftests/bpf/Makefile in v5.4 does not have the
> "skeleton header generation" stuff (circa v5.6).
> 
> Reverting c602ad2b52dc from linux-5.4.y fixes it.

Another option would be to just drop the selftest from linux-5.4.y,
but keep the beneficial change to kernel/bpf/hashtab.c.

(We're leaning towards that approach for Ubuntu).

 -Kamal
