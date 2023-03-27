Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB036CA727
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 16:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbjC0OND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 10:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232700AbjC0OMZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 10:12:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BD24ED1
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 07:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679926269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NvwxuKB1KAG0ACmsYDpkw14eOr4deO3U9ffm3RLnhIQ=;
        b=NMxaw98kv245bmyqI88ndHWacEao0ui4dIe+4jZMCaDoRoGQExjX4omfFf/QAAs/heVYZ7
        LgSTzsRsPT4L+0TBERVUUIZrvswVZfbcNA+h9D11Z9zs3yF+bddYh6pTnMp7KcHY4uVE7t
        wjSWaBYicwSADsK8hOCA3CeoDuoV9Xg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-498-j5kkvBeQMhWBAHJx14T-Gw-1; Mon, 27 Mar 2023 10:11:05 -0400
X-MC-Unique: j5kkvBeQMhWBAHJx14T-Gw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13E05884EC8;
        Mon, 27 Mar 2023 14:11:05 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1EB42027040;
        Mon, 27 Mar 2023 14:11:04 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     jpiotrowski@linux.microsoft.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Tianyu Lan <ltykernel@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Sean Christopherson <seanjc@google.com>, stable@vger.kernel.org
Subject: Re: [RESEND PATCH v2] KVM: SVM: Flush Hyper-V TLB when required
Date:   Mon, 27 Mar 2023 10:10:40 -0400
Message-Id: <20230327141039.3751076-1-pbonzini@redhat.com>
In-Reply-To: <20230324145233.4585-1-jpiotrowski@linux.microsoft.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Split svm_flush_tlb_current() into separate callbacks for the 3 cases
(guest/all/current), and issue the required Hyper-V hypercall when a
Hyper-V TLB flush is needed. The most important case where the TLB flush
was missing is when loading a new PGD, which is followed by what is now
svm_flush_tlb_current().

Queued, thanks.  I changed the return value to -EOPNOTSUPP.

Paolo


