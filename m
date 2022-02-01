Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD374A5498
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 02:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbiBABRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 20:17:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbiBABRD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 20:17:03 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF6DC06173B
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 17:17:03 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id y84so19376847iof.0
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 17:17:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RzbxR4Fdu7hWYUbItiGKOLsebowtj4komVuAo+cWSrw=;
        b=AxH9F+wXihg6B81PC5R/nTqNyxjQupGHxOz/T7Ljtv0/KBqm+va54YyCxhfcZ7Jm1r
         B5jrdVmgGO6aV4sOR92cmOnTrAlhZThPeC1L6UYCBTubvdq1tPBnLOXA7lyOXurcLoJh
         6X2H9RFJwEbZq+gKbktNRyWJxsmNuV0G3x9t1LQJj8g/8X2QzWtc/ujD6oR7jlcI45Dd
         L8PrCX4Mj2+cltt4f813oj2EfrLine3/wKJ3yR07a6wpsNU1oE1l+TnKDUtcgglmgm3V
         cUi9NLDTAKURA90OKm81151z0j3qsoVZ2VjhvYeIBinIsblQfxqUZildBzCmZMHqhUcp
         30Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RzbxR4Fdu7hWYUbItiGKOLsebowtj4komVuAo+cWSrw=;
        b=Z31Zyl/1vDaW1GDtvBwsQrzPwXNLO1FFQkIU2RWWjQnWJAFEl6ygNO6PaKh+NmxgWl
         5vBurlDWdoYZrep8iGmFtFw6gX1YgtJPI9Ik6sjOiBZSm19IdD00O5n7QYZaVxVdQiO8
         QDW3ISFr7OOr4mNtMJcsQa9dxDSp2IX8ZM6E/5sN0EUm8JnFKzmnKejFKjCXU29O8S0B
         8w5IOynV9zALWyXk3AMyKQfW1lSrrBkXShCWc9Lh9AOcFhlndKYdlq6ZUN7gDARDqt+s
         0jKQg4BZ14+AbdJpnKN/MWFThAQiTgBNSpl018lwfgZMst8xEK031LOeFApdo7ScBGty
         nVZg==
X-Gm-Message-State: AOAM5326nkfMNhQ+s45mzGHI4xZJvIQ/N8hTJal7W9VlkUxi4m2f2l3z
        k/9Tv8PHyXd//1B6Hywy7FjS2RbQ8mEUPbwA
X-Google-Smtp-Source: ABdhPJyBkRbYjCVXFGlhrNznlzz7OgLZm2NY4ZymQiv5Xa4hCz51Afx13fz0TQMg20eYEUXCEdRI+g==
X-Received: by 2002:a02:7b28:: with SMTP id q40mr8008428jac.198.1643678222468;
        Mon, 31 Jan 2022 17:17:02 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id k2sm5966919iow.7.2022.01.31.17.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 17:17:01 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     stable@vger.kernel.org
Cc:     davem@davemloft.net, elder@kernel.org
Subject: [PATCH 0/2] net: ipa: back-port concurrent replenish fix
Date:   Mon, 31 Jan 2022 19:16:56 -0600
Message-Id: <20220201011658.308283-1-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Attached are two patches that take the place of one IPA fix that was
requested for back-port.  The original did not apply cleanly, so one
prerequisite was back-ported, followed by the "real" fix.  They are
built upon Linux v5.10.95.

I wasn't sure how I was supposed to indicate this was a manual
back-port.  I added the upstream commit ID in each patch but it
needs to be edited.  And I added a "References" tag indicating the
e-mail to which this small series responds.

Please let me know if there's something else/more I should do.

Thanks.

					-Alex

Alex Elder (2):
  net: ipa: use a bitmap for endpoint replenish_enabled
  net: ipa: prevent concurrent replenish

 drivers/net/ipa/ipa_endpoint.c | 20 ++++++++++++++++----
 drivers/net/ipa/ipa_endpoint.h | 15 ++++++++++++++-
 2 files changed, 30 insertions(+), 5 deletions(-)

-- 
2.32.0

