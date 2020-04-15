Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D40521AA2E4
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503397AbgDONAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 09:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2505694AbgDONAX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 09:00:23 -0400
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 843C4C061A0C
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 06:00:22 -0700 (PDT)
Received: by mail-wm1-x349.google.com with SMTP id c196so2982507wmd.3
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 06:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Qr0e9VaHHqUEVdV52kGzkSBgp7xij5RTH7G4zE2O468=;
        b=Wa9Xmg6bfy86HBfQeVsk5Y1Aa/ufXQfw7dRiBBOakPQuBtYm9XuPyTGPFDOtnOtmqT
         0n9xXSA7nWmk51I4pP1echwnFqNiQZPknIxBu/0lOMnUJ4jexrLrNJImu5ThN+4Kuk+l
         kZGB4zmU1UISOmQuGfN7/kDYzfXKqg0eQe1DkYDGHeXLC9w+pUy7FEOQm+RdTNXS7Gne
         56ji6riGdinwdfZLu+saBiThLg5E65rJOPd5UlnKogqCqiwyACXF+H9Vzc9ru4+80bgq
         vUe2RbCwtRqzTC9yXk7wZjEKFMGiloCEOjnMrHmX1Hl/hey6qkLdNcrwEzW+5jMvB+YU
         CaAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Qr0e9VaHHqUEVdV52kGzkSBgp7xij5RTH7G4zE2O468=;
        b=XfHK45A9AbRm5XlAJtKNqZjMXpjJC/5lqEs6tK6/nhb64hUnOSnWmkrx8gD1SHprcz
         lXkR20iLuxGR+icO+H9ThXgJ56ElrBS8BoH1kfOY1KT0Sl+l//fFkBqk7CQ+r3pjtnBD
         x9Jay58IkF05/oi88QlGQ7ZcNJ10xEwsMZ5vvy3ToN+L0I6FruAdSllQYCiuvO4Hm3kN
         UgKdZNgISBAA7eoSnhaGh1jev0sXS76zXPVmyrglDUxKi2vX/vwjzXRt53bR104+Vbr6
         o3C0O5xtNCoHxQWh2kmhSAldy15E0ihD1GnvxFxciedl+T5UzyYIuUVhVnM8zD+plOY5
         oFeQ==
X-Gm-Message-State: AGi0Pub397AAbBMbeaU9qons0ep2N7T2zLl0d20GSOO6XhLLyH8VUzoE
        0Ab72q7+ekwWNSDjwfJDQFWunaoyNfSqMQ==
X-Google-Smtp-Source: APiQypJ8zbGCAM7bVwJTHDDsT0EXvyxKaXLpD9tRCSW8CAKoSEBGD/sEhbhaf3M8yYFysiJ+53dYhtgVWrBANQ==
X-Received: by 2002:a5d:6851:: with SMTP id o17mr3667179wrw.267.1586955620879;
 Wed, 15 Apr 2020 06:00:20 -0700 (PDT)
Date:   Wed, 15 Apr 2020 14:00:13 +0100
In-Reply-To: <CAGvU0Hn2U88Dy2MEP-ZTNvfrWaKF4XL9EtR+4iF5BZ6_GW3Tvg@mail.gmail.com>
Message-Id: <20200415130017.244979-1-gprocida@google.com>
Mime-Version: 1.0
References: <CAGvU0Hn2U88Dy2MEP-ZTNvfrWaKF4XL9EtR+4iF5BZ6_GW3Tvg@mail.gmail.com>
X-Mailer: git-send-email 2.26.0.110.g2183baf09c-goog
Subject: [PATCH v2 0/4] backport request for use-after-free blk_mq_queue_tag_busy_iter
From:   Giuliano Procida <gprocida@google.com>
To:     greg@kroah.com
Cc:     Giuliano Procida <gprocida@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

v2: Updated commit messages following feedback from gregkh.

Here are the patches for linux-4.4.y.

There are 2 further patches over those for linux-4.9.y and the
differences after back-porting are non-trivial.

The code complies without warnings. However, I have no suitable
hardware or virtual machine to test this on.

Regards,
Guiliano.

Giuliano Procida (4):
  block: more locking around delayed work
  blk-mq: Allow timeouts to run while queue is freezing
  blk-mq: sync the update nr_hw_queues with blk_mq_queue_tag_busy_iter
  blk-mq: Allow blocking queue tag iter callbacks

 block/blk-mq-tag.c  |  7 ++++++-
 block/blk-mq.c      | 17 +++++++++++++++++
 block/blk-timeout.c |  3 +++
 3 files changed, 26 insertions(+), 1 deletion(-)

-- 
2.26.0.110.g2183baf09c-goog

