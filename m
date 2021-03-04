Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79E5E32D600
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 16:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbhCDPHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 10:07:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:53032 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232697AbhCDPGe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 10:06:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1614870348; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=Vwzpu3uSoSBNAiO8Y4GaPtKbc9dyenaLIOLtsrz0N+s=;
        b=SPY1KKR+sZb4G1Ev9hn+gjgUBT2skAD/oD/W/5VgRXyjV5ZzUS1OjixEkiWi4dGJvBIfgc
        s9Ufc3AOPvqI9yO5aRc6ivn4xU+JGk+puWJTG9ThB2wHO8moSwrA79pF0w+7cuiq9grIoP
        w8jHlNn7cD2pk5Aila6GNl0cu1wS1+k=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1ED5CAC54;
        Thu,  4 Mar 2021 15:05:48 +0000 (UTC)
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>
Cc:     stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH STABLE ONLY] swap: fix swapfile page to sector mapping
Date:   Thu,  4 Mar 2021 16:08:20 +0100
Message-Id: <20210304150824.29878-1-ailiop@suse.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following patches fix the swapfile page-to-sector mapping for block
devices that implement rw_page for all the stable kernels.

This is related to the upstream fix of commit caf6912f3f4a ("swap: fix
swapfile read/write offset"), but for kernels prior to v5.12-rc1 the bug
only affects swapfiles that sit on top of block devices which provide a
rw_page operation.
