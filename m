Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 391FD2CF413
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 19:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730326AbgLDS3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 13:29:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47016 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgLDS3h (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Dec 2020 13:29:37 -0500
Received: from 2.general.kamal.us.vpn ([10.172.68.52] helo=ascalon)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kamal@canonical.com>)
        id 1klFp9-0001lf-8x; Fri, 04 Dec 2020 18:28:55 +0000
Received: from kamal by ascalon with local (Exim 4.90_1)
        (envelope-from <kamal@ascalon>)
        id 1klFp3-00075z-Nu; Fri, 04 Dec 2020 10:28:49 -0800
From:   Kamal Mostafa <kamal@canonical.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Verbeiren <david.verbeiren@tessares.net>,
        stable@vger.kernel.org
Subject: [5.4.y] selftests/bpf build broken by "bpf: Zero-fill..."
Date:   Fri,  4 Dec 2020 10:28:46 -0800
Message-Id: <20201204182846.27110-1-kamal@canonical.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha-

This v5.4.78 commit breaks the tools/testing/selftests/bpf build:

[linux-5.4.y] c602ad2b52dc bpf: Zero-fill re-used per-cpu map element

Like this:

	prog_tests/map_init.c:5:10: fatal error: test_map_init.skel.h: No such file or directory
	    5 | #include "test_map_init.skel.h"

Because tools/testing/selftests/bpf/Makefile in v5.4 does not have the
"skeleton header generation" stuff (circa v5.6).

Reverting c602ad2b52dc from linux-5.4.y fixes it.

 -Kamal
