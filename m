Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB6823CCBA3
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 01:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbhGRX57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Jul 2021 19:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbhGRX54 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Jul 2021 19:57:56 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6CCC061765
        for <stable@vger.kernel.org>; Sun, 18 Jul 2021 16:54:56 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id c12so1618723wrt.3
        for <stable@vger.kernel.org>; Sun, 18 Jul 2021 16:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7RvbFdwTjB3RgHhiockoPd8e4F9z8GNoiQcT8f0eKZA=;
        b=axXBTMARAC5U3piEe9Az/waiqJjTAfiL7VN+ZNIcN/81PbO4Neyph/tgcG01H8j5EL
         9VDu6YGISs3fw3hQ2ZdggZOmp4xY/pJUt5UK1Jlx/ssGwwbxwrtmWMREXm1LjYNnLevI
         pJ+GJuvSCJ/i+TazsgtZvPUdHTlTxZfA460qLKN1+o0gT716rqF7vogVAjEUd9ms0beq
         F50QaHneTJYBaCTiSvwV5/oPmUqX5aqKpYT3ZD2ID0TC3LTOdKeGbysjZ7RVqnr6LjW7
         oqhyE9rEYId0EM/0N5iZjGhJ2R4EemafVJxFWJlhTFLROMrpkvB23TDf535nJtI2XPd4
         VxnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7RvbFdwTjB3RgHhiockoPd8e4F9z8GNoiQcT8f0eKZA=;
        b=CVCEcIuUq6a7F2HPI9shL9xj5ohMpaBjUdX8L7N3KqsPZbCkch0FDr+sgthbfsgFO/
         R8iCdhZODSVob4NlfZhoSuyI6mBvVjCsx3wVHL33KCmJ2fcxC+n2Egp19/pptqA4TyO9
         eVCsBpCuDXiYlJIpBsCM4wXkLsNNLlgMeLQ3x9xnF4LEfm0cloeIrNE5wulkaXvGQQ0y
         clOh0TjJCcfbr4WJYwru5TkNSZoviHAUy3OEOla8wmbbKqOtiG0NmPwryQ5+3WdmJwLD
         EYlHxTA6oHNq6vJVCKoJ3lgmHv2vlbf09kOKRG7OxXjRk4DE6XT7AyGrA59AexSJBCFJ
         x7gw==
X-Gm-Message-State: AOAM532zl5sp0VwkFIrkNHlXLPZY21pR0akRokWYIi8tTey7JnnUdpxf
        Md8elb9JC0mAN9BK8yWOr70Xmrem3BpJdw==
X-Google-Smtp-Source: ABdhPJxmUFrrVt3QK+CdJGhC/glfJqL4Ah/FGTSZtaCOE+sAzNNAabQAW2U4s8IKfQrOsLFgEbKsvg==
X-Received: by 2002:a5d:50c7:: with SMTP id f7mr26352203wrt.126.1626652493913;
        Sun, 18 Jul 2021 16:54:53 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.101])
        by smtp.gmail.com with ESMTPSA id p18sm18098200wmg.46.2021.07.18.16.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jul 2021 16:54:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 0/2] stable-5.12 backport fixes
Date:   Mon, 19 Jul 2021 00:54:21 +0100
Message-Id: <cover.1626651114.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

a298232ee6b9a1 ("io_uring: fix link timeout refs") was backported,
however the second chunk of it got discarded, which breaks io_uring.
It depends on another patch, so backport it first (patch 1/2) and
then apply a298232ee6b9a1 again (patch 2/2).

It's a bit messy, the patch will be in the tree twice. Let me
know if there is a better way.

Pavel Begunkov (2):
  io_uring: put link timeout req consistently
  io_uring: fix link timeout refs

 fs/io_uring.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

-- 
2.32.0

